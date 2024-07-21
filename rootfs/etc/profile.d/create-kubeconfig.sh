#!/usr/bin/env sh

set -e

if [ -e /mnt/kubeconfig.yaml ]; then
    mkdir -p ~/.kube/
    cp -f /mnt/kubeconfig.yaml ~/.kube/config
    chmod 700 ~/.kube/config
fi
