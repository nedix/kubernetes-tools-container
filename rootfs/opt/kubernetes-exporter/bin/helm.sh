#!/usr/bin/env sh

for ARGUMENT in "$@"; do
    if [[ "$ARGUMENT" == --namespace=* ]]; then
        NAMESPACE="${ARGUMENT#*=}"
    fi

    if [[ "$ARGUMENT" == --release=* ]]; then
        RELEASE_NAME="${ARGUMENT#*=}"
    fi

    if [[ "$ARGUMENT" == --output=* ]]; then
        OUTPUT_FILE="${ARGUMENT#*=}"
    fi
done

RELEASE_VERSION=$(helm list --filter "^${RELEASE_NAME}$" --no-headers | sort -k3 | tail -n 1 | awk '{print $3}')

if [ -z "$RELEASE_VERSION" ]; then
    echo "Error: release not found." >&2
    exit 1
fi

RELEASE=$(kubectl get secret "sh.helm.release.v1.${RELEASE_NAME}.v${RELEASE_VERSION}" -n "$NAMESPACE" -o yaml -o custom-columns=:.data.release \
    | base64 -d \
    | base64 -d \
    | gzip -d \
)

RESOURCE_LIST=$(echo "$RELEASE" | yq eval '.manifest' | yq eval -N '.apiVersion + " " + .kind + " " + .metadata.name')

while read -r API_VERSION KIND RESOURCE_NAME; do
    if [[ "$API_VERSION" == */* ]]; then
        GROUP=$(echo "$API_VERSION" | cut -d/ -f1)
        VERSION=$(echo "$API_VERSION" | cut -d/ -f2)
    else
        GROUP=""
        VERSION="$API_VERSION"
    fi

    kubectl get "$KIND.$GROUP" "$RESOURCE_NAME" -n "$NAMESPACE" -o yaml | kubectl neat >> "$OUTPUT_FILE"
    echo "---" >> "$OUTPUT_FILE"
done <<< "$RESOURCE_LIST"
