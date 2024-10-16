#!/usr/bin/env sh

docker build -f Containerfile -t test .

test_runner() {
    set -e
    echo "Testing '$(basename ${1})'..."
    docker run --rm --entrypoint /bin/sh test -c "$(cat ${@})"
    echo "Good exit from '$(basename ${1})'."
}

for SCRIPT_NAME in \
    argocd.sh \
    exporter.sh \
    helm.sh \
    kfilt.sh \
    krew.sh \
    kubectl.sh \
    kustomize.sh \
    yq.sh \
; do
    SCRIPT_PATH="$(dirname ${0})/${SCRIPT_NAME}"

    test_runner "$SCRIPT_PATH"
done
