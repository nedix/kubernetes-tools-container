#!/usr/bin/env sh

for ARGUMENT in "$@"; do
  if [[ "$ARGUMENT" == --namespace=* ]]; then
    NAMESPACE="${ARGUMENT#*=}"
  fi

  if [[ "$ARGUMENT" == --output=* ]]; then
    OUTPUT_FILE="${ARGUMENT#*=}"
  fi
done

API_RESOURCES=$(kubectl api-resources --verbs=list --namespaced -o wide | awk ' \
    NR==1 {API_COL=index($0, "APIVERSION"); KIND_COL=index($0, "KIND")} \
    NR>1 {print substr($0, API_COL, index(substr($0, API_COL), " ")), substr($0, KIND_COL, index(substr($0, KIND_COL), " "))} \
')

while read -r API_VERSION KIND; do
    if [[ "$API_VERSION" == */* ]]; then
        GROUP=$(echo "$API_VERSION" | cut -d/ -f1)
        VERSION=$(echo "$API_VERSION" | cut -d/ -f2)
    else
        GROUP=""
        VERSION="$API_VERSION"
    fi

    RESOURCE_LIST=$(kubectl get "$KIND.$GROUP" -n "$NAMESPACE" -o yaml -o custom-columns=:.metadata.name --no-headers=true)

    [[ -n $RESOURCE_LIST ]] || continue

    for RESOURCE_NAME in $RESOURCE_LIST; do
        kubectl get "$KIND.$GROUP" "$RESOURCE_NAME" -n "$NAMESPACE" -o yaml | kubectl neat >> "$OUTPUT_FILE"
        echo "---" >> "$OUTPUT_FILE"
    done
done <<< "$API_RESOURCES"
