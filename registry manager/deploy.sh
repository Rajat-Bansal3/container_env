
##making a bridge network between 2 saperate services ( only required as harbor doesnt support docker swarm )

docker network create --driver bridge registry_network

# running verdaccio and Nexus using docker swarm

docker stack deploy -c docker-stack.yaml flow-registry

# running harbor 
docker compose -f harbor-compose.yaml up -d