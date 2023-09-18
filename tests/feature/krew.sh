#!/usr/bin/env bash

source "${0%/*}/_testcase.sh"

test_runner kubectl krew > /dev/null
