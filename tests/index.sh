#!/usr/bin/env sh

docker build . -t test

test_runner() {
    set -e
    echo "Testing '${1##*/}'..."
    docker run --rm -t test $@ > /dev/null
    echo "Good exit from '${1##*/}'."
}

export -f test_runner

${0%/*}/argocd.sh
${0%/*}/exporter.sh
${0%/*}/helm.sh
${0%/*}/kfilt.sh
${0%/*}/krew.sh
${0%/*}/kubectl.sh
${0%/*}/kustomize.sh
${0%/*}/yq.sh
