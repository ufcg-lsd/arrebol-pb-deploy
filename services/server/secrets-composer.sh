#!/bin/bash

ENV_FILE="services/conf-files/server/.env"
YAML_FILE="services/server/docker-stack.yml"

#Fulfill keys volume and configuration constants definition.
KEYS_PATH="go\/src\/github.com\/ufcg-lsd\/arrebol-pb\/keys"

sed -i "s/keys:/.\/keys:${KEYS_PATH}/" $YAML_FILE

echo >> $ENV_FILE
echo "ARREBOL_PRIV_KEY_PATH=$KEYS_PATH/arrebol_key" >> $ENV_FILE
echo "ARREBOL_PRIV_KEY_PATH=$KEYS_PATH/arrebol_key" >> $ENV_FILE
echo "KEYS_PATH=$KEYS_PATH" >> $ENV_FILE

#Fulfill allowlist volume and configuration constants definition.
ALLOW_LIST_PATH="go\/src\/github.com\/ufcg-lsd\/arrebol-pb\/allowlist"

sed -i "s/allowlist:/.\/allowlist:${ALLOW_LIST_PATH}/" $YAML_FILE

echo >> $ENV_FILE
echo "ALLOW_LIST_PATH=$ALLOW_LIST_PATH" >> $ENV_FILE