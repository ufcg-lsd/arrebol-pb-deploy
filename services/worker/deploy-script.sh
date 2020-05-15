#!/bin/bash

check_docker_installation() {
  sudo docker --version
  if [[ "$?" != 0 ]]; then
    sudo apt-get install docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
  fi
}

check_docker_installation

CONF_FILE_PATH="./worker-conf.json"
TAG=${1-latest}
IMAGE=ufcg-lsd/arrebol-worker:$TAG
ID=worker_id=`jq .Id $CONF_FILE_PATH`
CONTAINER_NAME=arrebol-worker-$ID

sudo docker pull $IMAGE
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME
sudo docker run --name $CONTAINER_NAME -tdi $IMAGE

PROJECT_PATH="/go/src/github.com/ufcg-lsd/arrebol-pb-worker"

sudo docker cp $CONF_FILE_PATH $CONTAINER_NAME:$PROJECT_PATH/worker
sudo docker cp "./.env" $CONTAINER_NAME:$PROJECT_PATH
sudo docker exec $CONTAINER_NAME /bin/bash -c "$PROJECT_PATH/main"

