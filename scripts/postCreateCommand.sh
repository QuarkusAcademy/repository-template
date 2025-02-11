#!/bin/bash

. ${NVM_DIR}/nvm.sh 
nvm install --lts
devbox install

echo "postCreateCommand finished"
