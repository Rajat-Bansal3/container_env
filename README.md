🛡️ Ubuntu SSH Secure Server
============================

📌 Overview
------------

This project provides a **containerized Ubuntu server** with **SSH access**, secured using multiple layers of protection, including **UFW, iptables, inactivity timeouts, and Fail2Ban**. The goal is to create a **hardened and minimal** SSH-accessible environment while allowing customization for further security enhancements.

This project is **open for contributions**, aiming to improve security, configurations, and best practices in containerized environments.

🚀 Features
-----------

*   🔒 **Secure SSH Access** – Run an SSH server inside a Docker container.
    
*   🛡 **Firewall Protection** – Configured with **UFW** and **iptables** to block unauthorized access.
    
*   ⏳ **Inactivity Timeout** – Automatically disconnects idle SSH sessions to prevent unauthorized usage.
    
*   🚫 **Intrusion Prevention** – Uses **Fail2Ban** to detect and ban repeated failed login attempts.
    
*   🔄 **Lightweight & Portable** – Easily deploy on any system with Docker.
    

🛠️ Getting Started
-------------------

### 🔹 Pull the Docker Image

docker pull rajatbansalx86/ubuntu\_ssh\_secure\_server

### 🔹 Run the Container

    docker run -d --name secure-ssh \
    -p 2222:22  \
    -p 3000:3000 
    rajatbansalx86/ubuntu\_ssh\_secure\_server

This runs the SSH server inside a Docker container and exposes it on **port 2222** and give an express endpoint to download ssh keys at **/download-ssh-key at port 3000**

### 🔹Change the configs of fail2ban or sshd.conf accordingly
change the files in the directory 
  - fall2ban.local
  - sshd.conf 

### 🔹 Connect via SSH

ssh -i *downloaded_private_key* sshuser@localhost -p *port*

Replace `downloaded_private_key` with the correct SSH key and `port` with the container's mapped port.

🔐 Security Enhancements
------------------------

This project follows best security practices:

1.  **UFW (Uncomplicated Firewall)** – Restricts access to essential ports.
    
2.  **iptables Rules** – Manages traffic flow and prevents unauthorized access.
    
3.  **SSH Inactivity Timeout** – Users are automatically disconnected after inactivity.
    
4.  **Fail2Ban Protection** – Blocks IPs after multiple failed login attempts.
    

🌍 Contributing
---------------

This project is open to contributions! If you have suggestions for improving security, optimizing performance, or adding new features:

1.  **Fork the repository** on GitHub.
    
2.  **Submit a pull request** with your changes.
    
3.  **Report issues** or suggest improvements via GitHub issues.
    

Let's build a **more secure** and **optimized** containerized SSH server together! 🚀

📜 License
----------

This project is open-source and available under the **MIT License**.

📧 Contact
**Rajat Bansal** - _rajatbansal28082003@gmail.com_