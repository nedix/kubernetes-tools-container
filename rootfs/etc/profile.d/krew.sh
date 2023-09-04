#!/usr/bin/env sh

export PATH=$(echo "$PATH" | sed "s|/usr/local/bin|/usr/local/bin:/opt/krew/bin|")
