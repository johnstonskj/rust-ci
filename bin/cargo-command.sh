#!/usr/bin/env bash

source $CARGO_BIN/cargo-config.sh

if [[ $# -lt 1 ]] ; then
    fatal "no CARGO_COMMAND argument supplied"
fi

if [[ $CARGO_WORKSPACE = 1 ]] ; then
    WS_FLAGS="--all"
else
    WS_FLAGS=""
fi

CARGO_COMMAND=$1
shift

debug "running $CARGO_COMMAND"

if [[ $# = 0 ]] ; then
    cargo $CARGO_COMMAND $CARGO_FLAGS $WS_FLAGS
else
    cargo $CARGO_COMMAND $CARGO_FLAGS $WS_FLAGS -- $*
fi
