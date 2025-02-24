🖥️ Secure Server Configuration & API
=====================================

📌 Overview
-----------

This project includes a **Node.js-based server** (`server.js`) running on **port 3000**, designed to manage and modify security configurations of an SSH-secured Ubuntu container. The server provides RESTful APIs to modify and retrieve configurations for SSH and Fail2Ban services.

🚀 Endpoints
------------

The server exposes the following endpoints:

### 🔧 Configuration Management

*   `**POST /modify-sshd-config**` – Modify SSH daemon (`sshd`) configuration.
    
*   `**POST /modify-fail2ban-config**` – Modify Fail2Ban configuration.
    
*   `**GET /current-sshd-config**` – Retrieve the current `sshd_config` settings.
    
*   `**GET /current-fail2ban-config**` – Retrieve the current Fail2Ban configuration.

## 🔧 Configuration Management via build

*   `**entrypoint.sh**` - Modify this file to change default iptables configurations.
  
*   `**sshd.conf**` - Modify this file to change default sshd configurations  
    
*   `**fail2ban.local**` - Modify this file to change default fail2ban configurations  

    

### 🔑 SSH Key Management

*   `**GET /download-ssh-key**` – Allows users to download their private SSH key for secure access.
    

### 🔍 Service Status

*   `**GET /services**` – Provides the status of running security-related services.
    

📦 Dockerfile Setup
-------------------

The `Dockerfile` is responsible for setting up and securing the container environment with SSH and system security configurations.

### 🔹 Key Setup Steps

1.  **Installs necessary packages** for a minimal setup.
    
2.  **Copies pre-defined SSH service configurations** from the build context.
    
3.  **Sets up an SSH user** with secure authentication mechanisms.
    
4.  **Configures SSH securely**, including disabling root login and enforcing key-based authentication.
    
5.  **Applies system security configurations**, protecting against spoofing and odd network attacks.
    
6.  **Configures iptables** for traffic management and security via copying entrypoint.sh from repo to container to solve network build time issue.
    
7.  **Exposes necessary ports**:
    
    *   **Port 443**: Used as the SSH access port (default SSH port changed to `443`).
        
    *   **Port 3000**: Optional, used only if the server is enabled for modifying configurations.
        

🔐 Security Measures
--------------------

The project follows strict security protocols:

*   **SSH hardening** – Secure configuration applied to `sshd_config`.
    
*   **UFW firewall & iptables rules** – Protect the container from unauthorized access.
    
*   **Fail2Ban** – Prevent brute-force attacks.
    
*   **System tweaks** – Includes protection against IP spoofing and unnecessary network exposure.
    

🌍 Contributions
----------------

This project is **open for contributions**. If you have improvements, security enhancements, or feature suggestions:

1.  **Fork the repository**.
    
2.  **Submit a pull request** with your changes.
    
3.  **Report issues** for discussion and improvements.
    

Let's work together to build a **more secure** and **efficient** containerized SSH environment! 🚀