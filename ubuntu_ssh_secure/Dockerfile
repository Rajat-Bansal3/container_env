# Base Image for Running Node Script
FROM node:18-slim AS server

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY server.js .

# Main Ubuntu Server Setup
FROM ubuntu AS base

WORKDIR /root

COPY --from=server /app /home/ubuntu/

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl openssh-server fail2ban iptables iptables-persistent sudo auditd && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && apt-get install -y auditd && apt-get clean

RUN systemctl enable auditd


COPY fail2ban.local /etc/fail2ban/fail2ban.local
COPY sshd.conf /etc/fail2ban/filter.d/sshd.conf

RUN useradd -m -s /bin/bash sshuser && \
    mkdir -p /home/sshuser/.ssh && chmod 700 /home/sshuser/.ssh && \
    ssh-keygen -t rsa -b 4096 -f /home/sshuser/.ssh/id_rsa -N "" && \
    cp /home/sshuser/.ssh/id_rsa.pub /home/sshuser/.ssh/authorized_keys && chmod 600 /home/sshuser/.ssh/authorized_keys && \
    chown -R sshuser:sshuser /home/sshuser/.ssh

RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 360" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config && \
    echo "Port 443" >> /etc/ssh/sshd_config && \
    echo "AllowUsers sshuser" >> /etc/ssh/sshd_config

RUN echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf && \
    echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf && \
    echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf && \
    sysctl -p


RUN systemctl enable auditd

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 443 3000

CMD ["sh", "-c", "service ssh start && /entrypoint.sh && service fail2ban start && iptables-restore < /etc/iptables/rules.v4 && node /home/ubuntu/server.js"]