#!/bin/bash

check_ansible_installation() {
  ansible --version
  if [[ "$?" != 0 ]]; then
    sudo apt-get install ansible
  fi
}

check_ansible_installation

HOSTS_CONF_FILE="$(pwd)/conf-files/hosts.conf"
ANSIBLE_HOSTS_FILE="$(pwd)/ansible/worker/hosts"
ANSIBLE_CFG_FILE="$(pwd)/ansible/worker/ansible.cfg"

# setup hosts
WORKER_HOST_IP=$(grep ^worker_host $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
echo $WORKER_HOST_IP_PATTERN
sed -i '/\[worker-machine\]/,/\[worker-machine:vars\]/{//!d}' ${ANSIBLE_HOSTS_FILE}
sed -i "/\[worker-machine:vars\]/i ${WORKER_HOST_IP}" ${ANSIBLE_HOSTS_FILE}

WORKER_NODE_HOST_IP=$(grep ^worker_node_host $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
sed -i '/\[worker-node-machine\]/,/\[worker-node-machine:vars\]/{//!d}' ${ANSIBLE_HOSTS_FILE}
sed -i "/\[worker-node-machine:vars\]/i ${WORKER_NODE_HOST_IP}" ${ANSIBLE_HOSTS_FILE}

ANSIBLE_SSH_PRIVATE_KEY_FILE=$(grep ^private_key_path $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PRIVATE_KEY_FILE_PATH_PATTERN="ansible_ssh_private_key_file"
sed -i "s#.*$PRIVATE_KEY_FILE_PATH_PATTERN=.*#$PRIVATE_KEY_FILE_PATH_PATTERN=$ANSIBLE_SSH_PRIVATE_KEY_FILE#g" $ANSIBLE_HOSTS_FILE

#setup ansible.cfg
REMOTE_USER=$(grep ^remote_host_user $HOSTS_CONF_FILE | awk -F "=" '{print $2}')
PATTERN_HELPER="remote_user"
sed -i "s#.*$PATTERN_HELPER = .*#$PATTERN_HELPER = $REMOTE_USER#g" $ANSIBLE_CFG_FILE

#cd ansible/worker && ansible-playbook -vvv deploy.yml