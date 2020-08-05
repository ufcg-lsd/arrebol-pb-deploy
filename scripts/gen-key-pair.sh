#!/bin/bash

KEYS_PATH=$1

ssh-keygen -t rsa -b 4096 -N "" -f arrebol_key
ssh-keygen -f arrebol_key.pub -e -m pem > arrebol_key.pem

mv ./arrebol_key ./arrebol_key.pub ./arrebol_key.pem $KEYS_PATH