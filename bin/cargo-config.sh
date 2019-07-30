#!/usr/bin/env bash

if [[ "$CARGO_BIN" = "" ]] ; then
    CARGO_BIN=$(dirname "$0")
fi

if [[ ! -f "Cargo.toml" ]] ; then
    echo "Fatal: no Cargo.toml file, are you running in your project root?" 2>&1
    exit 1
fi

if $(grep -q "^\[workspace\]$" Cargo.toml) ; then
    export CARGO_WORKSPACE=1
    #
    # This will extract the set of members from the workspace's Cargo.toml
    # file, it will construct a comma separated list in the $CRATES
    # environment variable, these SHOULD be listed in order of dependency
    # in your workspace so that publish steps can work effectively.
    #
    export CRATES=$(cat Cargo.toml \
        | egrep -o '"[^"]+"' \
        | tr '"'  ' ' \
        | tr '\n' ' ' \
        | tr -s '[:space:]' \
        | sed -e 's/^[[:space:]]*//' \
        | sed -e 's/[[:space:]]*$//' \
        | tr ' ' ',' \
    )
    echo "Info: cargo workspace contains ( $CRATES ) crates"
else
    export CARGO_WORKSPACE=0
fi

if [[ $CARGO_DEBUG = 1 ]] ; then
    echo "Debug: setting debug flags"
    RUST_BACKTRACE=1
    RUST_LOG=info
    if [[ ! $CARGO_FLAGS = *verbose* ]] ; then
	CARGO_FLAGS="$CARGO_FLAGS --verbose"
    fi
fi

fatal() {
    error $@
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
