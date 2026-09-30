#!/usr/bin/env sh

if [ ! -e /mnt/kubeconfig.yaml ]; then
    echo "ERROR: File \`/mnt/kubeconfig.yaml\` not found."
    exit 1
fi

mkdir -p "${HOME}/.kube/"

sync-kubeconfig() {
    local CLUSTER_INDEX=0
    local KUBERNETES_CONFIG="$(cat /mnt/kubeconfig.yaml)"

    while [ "$CLUSTER_INDEX" -lt "$(echo "$KUBERNETES_CONFIG" | yq '.clusters | length')" ]; do
        local SERVER_ADDRESS=$(echo "$KUBERNETES_CONFIG" | yq ".clusters[${CLUSTER_INDEX}].cluster.server")
        local SERVER_IP=""
        local SERVER_PORT=""

        if echo "$SERVER_ADDRESS" | grep -qE '^https?://0\.0\.0\.0:[0-9]+$'; then
            SERVER_IP="0.0.0.0"
        fi

        if echo "$SERVER_ADDRESS" | grep -qE '^https?://127\.0\.0\.1:[0-9]+$'; then
            SERVER_IP="127.0.0.1"
        fi

        if test -z "$SERVER_IP"; then
            continue
        fi

        SERVER_PORT=$(echo "$SERVER_ADDRESS" | awk -F: '{print $3}')

        if (! nc -z "$SERVER_IP" "$SERVER_PORT" && nc -z "host.docker.internal" "$SERVER_PORT") 1> /dev/null 2> /dev/null; then
            KUBERNETES_CONFIG=$(
                echo "$KUBERNETES_CONFIG" \
                | yq ".clusters[${CLUSTER_INDEX}].cluster.server |= sub(\"${SERVER_IP}\", \"host.docker.internal\")" \
                | yq ".clusters[${CLUSTER_INDEX}].cluster |= del(.certificate-authority-data)" \
                | yq ".clusters[${CLUSTER_INDEX}].cluster.insecure-skip-tls-verify = true" \
            )

            echo "INFO: Patched cluster #${CLUSTER_INDEX}."
        fi

        CLUSTER_INDEX="$(( CLUSTER_INDEX + 1 ))"
    done

    echo "$KUBERNETES_CONFIG" > "${HOME}/.kube/config"
}

sync-kubeconfig

inotifywait -e create,modify -m /mnt/kubeconfig.yaml -qq \
| while read -r _; do
    sync-kubeconfig
done &
