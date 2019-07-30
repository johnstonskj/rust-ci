#!/usr/bin/env bash

if [[ "$CARGO_LOG_NAME" = "" ]] ; then
    CARGO_LOG_NAME="rust-ci"
fi

fatal() {
    error $@
    exit 1
}

error() {
    echo "[$CARGO_LOG_NAME] Error: $@" 2>&1
}

warning() {
    echo "[$CARGO_LOG_NAME] Warning: $@" 2>&1
}

info() {
    echo "[$CARGO_LOG_NAME] Info: $@"
}

debug() {
    if [[ $CARGO_DEBUG = 1 ]] ; then
        echo "[$CARGO_LOG_NAME] Debug: $@"
    fi
}
