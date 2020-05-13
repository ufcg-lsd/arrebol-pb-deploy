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
REPO_URL="https://github.com/ufcg-lsd/arrebol-pb-worker.git"

git clone $REPO_URL

TAG=${1-latest}
IMAGE=ufcg-lsd/arrebol-worker:$TAG
ID=worker_id=`jq .Id $CONF_FILE_PATH`
CONTAINER_NAME=arrebol-worker-$ID

sudo docker pull $IMAGE
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME
sudo docker run --name $CONTAINER_NAME -tdi $IMAGE

sudo docker cp $CONF_FILE_PATH  $CONTAINER_NAME:/go/src/github.com/ufcg-lsd/arrebol-pb-worker/worker
sudo docker exec $CONTAINER_NAME /bin/bash -c "/go/src/github.com/ufcg-lsd/arrebol-pb-worker/main"

