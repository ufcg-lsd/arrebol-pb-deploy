#!/bin/bash

check_ansible_installation() {
  ansible --version
  if [[ "$?" != 0 ]]; then
    sudo apt-get install ansible
  fi
}

check_ansible_installation

HOSTS_CONF_FILE="$(pwd)/conf-files/hosts.conf"
ANSIBLE_HOSTS_FILE="$(pwd)/ansible/server/hosts"
ANSIBLE_CFG_FILE="$(pwd)/ansible/server/ansible.cfg"

# setup hosts
SERVER_HOST_IP=$(grep ^server_host $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
sed -i '/\[server-machine\]/,/\[server-machine:vars\]/{//!d}' ${ANSIBLE_HOSTS_FILE}
sed -i "/\[server-machine:vars\]/i ${WORKER_HOST_IP}" ${ANSIBLE_HOSTS_FILE}

ANSIBLE_SSH_PRIVATE_KEY_FILE=$(grep ^private_key_path $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PRIVATE_KEY_FILE_PATH_PATTERN="ansible_ssh_private_key_file"
sed -i "s#.*$PRIVATE_KEY_FILE_PATH_PATTERN=.*#$PRIVATE_KEY_FILE_PATH_PATTERN=$ANSIBLE_SSH_PRIVATE_KEY_FILE#g" $ANSIBLE_HOSTS_FILE

#setup ansible.cfg
REMOTE_USER=$(grep ^remote_host_user $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PATTERN_HELPER="remote_user"
sed -i "s#.*$PATTERN_HELPER = .*#$PATTERN_HELPER = $REMOTE_USER#g" $ANSIBLE_CFG_FILE

mkdir -p $(pwd)/services/conf-files/server/keys
./scripts/gen-key-pair.sh $(pwd)/services/conf-files/server/keys
./services/server/secrets-composer.sh

#cd ansible/server && ansible-playbook -vvv deploy.yml