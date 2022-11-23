#!/bin/bash

kubectl create secret generic registry-ca --namespace kube-system --from-file=registry-ca=/opt/keys/certs.d/${KUBEHEAD}\:443/ca.crt
kubectl create -f registry-ca-ds.yaml
kubectl create secret generic regcred --from-file=.dockerconfigjson=/users/${USER}/.docker/config.json --type=kubernetes.io/dockerconfigjson -n jenkins