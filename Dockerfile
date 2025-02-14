## for running node script to download key ##
FROM node:18-slim AS server

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY server.js .


## main ubuntu configs
FROM ubuntu AS base

COPY --from=server /app /home/ubuntu/

## installing packages ##
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl openssh-server && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt install -y nodejs && apt install -y fail2ban

COPY fail2ban.local /etc/fail2ban/fail2ban.local

COPY sshd.conf /etc/fail2ban/filter.d/sshd.conf

RUN useradd -m -s /bin/bash sshuser

RUN mkdir -p /home/sshuser/.ssh && chmod 700 /home/sshuser/.ssh

RUN ssh-keygen -t rsa -b 4096 -f /home/sshuser/.ssh/id_rsa -N ""

RUN cp /home/sshuser/.ssh/id_rsa.pub /home/sshuser/.ssh/authorized_keys && chmod 600 /home/sshuser/.ssh/authorized_keys

RUN chown -R sshuser:sshuser /home/sshuser/.ssh


## ssh configs ##
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&  echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_configz && echo "ClientAliveInterval 360" >> /etc/ssh/sshd_config && echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config


## port exposes
EXPOSE 22 3000


##commands on enter
CMD ["sh", "-c", "service ssh start && node /home/ubuntu/server.js && service fail2ban start"]
