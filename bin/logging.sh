#!/usr/bin/env bash

fatal() {
    error $@
    exit 1
}

error() {
    echo "Error: $@" 2>&1
}

warning() {
    echo "Warning: $@" 2>&1
}

info() {
    echo "Info: $@"
}

debug() {
    if [[ $CARGO_DEBUG = 1 ]] ; then
        echo "Debug: $@"
    fi
}
