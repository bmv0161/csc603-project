#!/bin/bash

cd
export KUBEHEAD=$(kubectl get nodes -o custom-columns=NAME:.status.addresses[1].address,IP:.status.addresses[0].address | grep head | awk -F ' ' '{print $2}')
ssh-keygen
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
cat ~/.ssh/id_rsa