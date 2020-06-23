#!/bin/bash

check_docker_installation() {
  sudo docker --version
  EXIT_CODE=$?
  if [[ $EXIT_CODE -ne 0 ]]; then
    sudo apt-get install docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
  fi
}

check_docker_installation

readonly CONF_FILE_PATH="./worker-conf.json"
TAG=${1-latest}
readonly IMAGE=raonismaneoto/arrebol-worker
ID=`jq .Id $CONF_FILE_PATH`
#Remove quotations marks from ID
ID=${ID%\"}
ID=${ID#\"}

CONTAINER_NAME=arrebol-worker-$ID

sudo docker pull $IMAGE
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME
sudo docker run --name $CONTAINER_NAME -tdi \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /usr/bin/docker:/usr/bin/docker \
        $IMAGE:$TAG

PROJECT_PATH="/go/src/github.com/ufcg-lsd/arrebol-pb-worker"
KEYS_DIR=$(grep ^KEYS_PATH ./.env | awk -F "=" '{print $2}')

SERVER_ENDPOINT=$(grep ^SERVER_USER_API_ENDPOINT ./.env | awk -F "=" '{print $2}')
curl $SERVER_ENDPOINT/publickey > ./server.pub
sudo chmod 644 ./server.pub

sudo docker cp $CONF_FILE_PATH $CONTAINER_NAME:$PROJECT_PATH/worker
sudo docker cp "./.env" $CONTAINER_NAME:$PROJECT_PATH
sudo docker exec $CONTAINER_NAME /bin/bash -c "mkdir -p $KEYS_DIR"
sudo docker cp "./server.pub" $CONTAINER_NAME:$KEYS_DIR
sudo docker exec $CONTAINER_NAME /bin/bash -c "$PROJECT_PATH/main" &

