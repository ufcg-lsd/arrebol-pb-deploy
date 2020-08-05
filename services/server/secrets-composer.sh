#!/bin/bash

ENV_FILE="../conf-files/server/.env"
YAML_FILE="./docker-stack.yaml"

#Fulfill keys volume and configuration constants definition.
KEYS_PATH="go/src/github.com/ufcg-lsd/arrebol-pb/keys"

sed -e '0,/keys:/ s/keys:/.\/keys:$KEYS_PATH/' $YAML_FILE

echo "ARREBOL_PRIV_KEY_PATH=$KEYS_PATH/arrebol_key" >> $ENV_FILE
echo "ARREBOL_PRIV_KEY_PATH=$KEYS_PATH/arrebol_key" >> $ENV_FILE
echo "KEYS_PATH=$KEYS_PATH" >> $ENV_FILE

#Fulfill allowlist volume and configuration constants definition.
ALLOW_LIST_PATH="go/src/github.com/ufcg-lsd/arrebol-pb/allowlist"

sed -e '0,/allowlist:/ s/allowlist:/.\/allowlist:$ALLOW_LIST_PATH' $YAML_FILE

echo "ALLOW_LIST_PATH=$ALLOW_LIST_PATH" >> $ENV_FILE