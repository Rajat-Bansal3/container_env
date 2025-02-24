Multi-Registry Setup with Nexus, Verdaccio, and Harbor
======================================================

This project demonstrates the setup of three separate registries for different package managers and container images:

*   **Nexus**: A universal repository manager for various package formats.
    
*   **Verdaccio**: A lightweight private npm registry.
    
*   **Harbor**: A trusted cloud-native registry for Docker images.
    

The setup is implemented in two ways:

1.  **Single Replica using Docker Compose**: A simple, single-node setup for local development or testing.
    
2.  **Docker Swarm**: A multi-node, scalable setup using Docker Swarm (Nexus and Verdaccio only, as Harbor does not support Swarm).
    

A **Kubernetes (k8s)** setup is also planned for the future to extend this project to a cloud-native environment.

* * *

Features
--------

*   **Nexus**: Centralized management of Maven, npm, Docker, and other package formats.
    
*   **Verdaccio**: Private npm registry for secure package hosting.
    
*   **Harbor**: Secure and scalable Docker image registry with vulnerability scanning and role-based access control.
    
*   **Docker Compose**: Easy-to-deploy single-replica setup for local environments.
    
*   **Docker Swarm**: Scalable and fault-tolerant setup for production-like environments.
    
*   **Future Plans**: Kubernetes-based deployment for cloud-native orchestration.
    

* * *

Project Structure
-----------------

The project includes the following key files:

*   `docker-compose.yaml`: Docker Compose configuration for a single-replica setup.
    
*   `docker-stack.yaml`: Docker Swarm configuration for a multi-node setup.
    
*   `deploy.sh`: A helper script to deploy the stack in Docker Swarm mode.
    

* * *

Setup Instructions
------------------

### Prerequisites

*   Docker installed on your machine.
    
*   Docker Swarm initialized (for Swarm setup).
    

* * *

### Docker Compose (Single Replica)

1.  Clone the repository:
    
    bash
    
    Copy
    
    git clone https://github.com/your-username/multi-registry-setup.git
    
2.  Navigate to the project directory:
    
    bash
    
    Copy
    
    cd multi-registry-setup
    
3.  Start the services using Docker Compose:
    
    bash
    
    Copy
    
    docker-compose \-f docker-compose.yaml up \-d
    

* * *

### Docker Swarm (Multi-Node)

1.  Navigate to the project directory

    
2.  Initialize Docker Swarm (if not already initialized):
    
    
    
3.  Deploy the stack using the `deploy.sh` script:
    

* * *

### `deploy.sh` Script

The `deploy.sh` script automates the deployment process for Docker Swarm. It performs the following steps:

1.  Checks if Docker Swarm is initialized.
    
2.  Deploys the stack using `docker-stack.yaml`.

3.  Deploy.sh is just for deploying docker-stack.yaml file in a local swarm cluster

4.  For spinning up a compose single relica services use command:
    
    COPY
    bash
    `
    docker compose -f docker-compose.yaml
    `


To use the script:

bash

Copy

chmod +x deploy.sh
./deploy.sh

* * *

Future Work
-----------

*   **Kubernetes Setup**: Deploy Nexus, Verdaccio, and Harbor on a Kubernetes cluster for cloud-native scalability and resilience.
    

* * *

Contributing
------------

Contributions are welcome! Please open an issue or submit a pull request with your suggestions or improvements.

* * *

Connect
-------

For questions or feedback, feel free to reach out or open an issue on GitHub.

* * *

Let me know if you need further adjustments! 😊