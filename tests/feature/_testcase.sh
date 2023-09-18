#!/usr/bin/env bash

function test_runner() {
    set -e
    echo "Testing '${1##*/}'..."
    docker run --rm -t kubernetes-tools $@ > /dev/null
    echo "Good exit from '${1##*/}'."
}

 export -f test_runner
