#!/bin/bash

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
    exit 1
fi

DOCKER_VERSION=$(docker version --format '{{.Server.Version}}')
echo "Docker Version: $DOCKER_VERSION"

SWARM_STATUS=$(docker info --format '{{.Swarm.LocalNodeState}}')
if [[ "$SWARM_STATUS" == "active" || "$SWARM_STATUS" == "inactive" ]]; then
    echo "Docker Swarm is available (Status: $SWARM_STATUS)"
else
    echo "Docker Swarm is NOT available."
fi

if docker stack --help &> /dev/null; then
    echo "Docker Stack is supported."
else
    echo "Docker Stack is NOT supported."
fi

if [[ "${PWD##*/}" != "registry manager" ]]; then
    echo "Not in the correct repo folder: 'registry manager'"
    exit 1
fi

if [[ "$SWARM_STATUS" == "inactive" ]]; then
    echo "Initializing Docker Swarm..."
    docker swarm init
fi

echo "Pre-pulling necessary images..."
docker pull postgres:14
docker pull redis:alpine
docker pull sonatype/nexus3
docker pull verdaccio/verdaccio

# Deploy the stack using Docker Swarm
echo "Deploying flow-registry stack..."
docker stack deploy -c docker-stack.yaml flow-registry
