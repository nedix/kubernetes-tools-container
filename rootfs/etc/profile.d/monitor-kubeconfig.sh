#!/usr/bin/env sh

set -e

mkdir -p ~/.kube/

sync-kubeconfig() {
    if [ ! -e /mnt/kubeconfig.yaml ]; then
        exit
    fi

    yq '(.clusters[].cluster.server |= sub("0\\.0\\.0\\.0", "host.docker.internal"))' /mnt/kubeconfig.yaml \
    > ~/.kube/config
}

sync-kubeconfig

inotifywait -qq -e create,modify -m /mnt/kubeconfig.yaml \
| while read -r _; do
    sync-kubeconfig
done &
