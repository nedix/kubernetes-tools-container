#!/usr/bin/env bash

source "${0%/*}/_testcase.sh"

test_runner kfilt -f http://bit.ly/2xSiCJL -i kind=ServiceAccount > /dev/null
