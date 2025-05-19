#!/usr/bin/env sh

sync-kubeconfig() {
    mkdir -p ~/.kube/

    if [ ! -e /mnt/kubeconfig.yaml ]; then
        return
    fi

    CLUSTER_INDEX=0
    KUBERNETES_CONFIG="$(cat /mnt/kubeconfig.yaml)"

    while [ "$CLUSTER_INDEX" -lt "$(echo "$KUBERNETES_CONFIG" | yq '.clusters | length')" ]; do
        SERVER=$(echo "$KUBERNETES_CONFIG" | yq ".clusters[${CLUSTER_INDEX}].cluster.server")

        if echo "$SERVER" | grep -qE '^https?://0\.0\.0\.0:[0-9]+$'; then
            PORT=$(echo "$SERVER" | awk -F: '{print $3}')

            if (! nc -z "0.0.0.0" "$PORT" && nc -z "host.docker.internal" "$PORT") 1> /dev/null 2> /dev/null; then \
                KUBERNETES_CONFIG=$( \
                    echo "$KUBERNETES_CONFIG" \
                    | yq ".clusters[${CLUSTER_INDEX}].cluster.server |= sub(\"0.0.0.0\", \"host.docker.internal\")" \
                )
            fi
        fi

        CLUSTER_INDEX="$(( CLUSTER_INDEX + 1 ))"
    done

    echo "$KUBERNETES_CONFIG" > ~/.kube/config
}

sync-kubeconfig

inotifywait -e create,modify -m /mnt/kubeconfig.yaml -qq \
| while read -r _; do
    sync-kubeconfig
done &
