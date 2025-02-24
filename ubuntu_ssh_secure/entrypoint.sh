iptables -P INPUT DROP && \
iptables -P FORWARD DROP && \
iptables -P OUTPUT ACCEPT && \
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT && \
iptables -A INPUT -i lo -j ACCEPT && \
iptables -A INPUT -p tcp --dport 443 -j ACCEPT && \
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT && \
iptables-save > /etc/iptables/rules.v4 