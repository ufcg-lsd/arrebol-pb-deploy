#!/bin/bash

check_docker_installation() {
  sudo docker --version
  EXIT_CODE=$?
  if [[ $EXIT_CODE -ne 0 ]]; then
    sudo apt-get install docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
  fi

  sudo docker-compose -version
  EXIT_CODE=$?
  if [[ $EXIT_CODE -ne 0 ]]; then
    sudo apt-get install docker-compose
  fi
}

check_docker_installation

sudo docker-compose up ./docker-stack.yml
