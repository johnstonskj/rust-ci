# rust-ci

This repo contains a set of CI scripts (tested with Travis) for 
Rust projects that can be integrated into `.travis.yml` 
configuration.

## Configuration

Add the following block to your configuration.

``` yaml
env:
  global:
  - CARGO_CI=ci
  - CARGO_DEBUG=1
  - CARGO_FLAGS=--verbose
  - CARGO_LINTER=fmt
  - CARGO_LOG_NAME=my-project
  - CARGO_DEPLOY=1
```

* `CARGO_CI` - the directory you cloned this repo into.
* `CARGO_DEBUG` - set to 1 to enable debugging (sets RUST_BACKTRACE,
  RUST_LOG, CARGO_FLAGS, and enables the script's `debug` function;
  defaults to 0.
* `CARGO_FLAGS` - any flags you want to pass into any/all Cargo
  commands; defaults to none.
* `CARGO_LINTER`- a comma separated list of cargo commands you want
  to run as linters; defaults to an emoty list.
* `CARGO_LOG_NAME` - optional, sets the name of the logger used when 
  outputting messages; defaults to 'rust-ci'.
* `CARGO_DEPLOY`- set to 1 to enable the deployments executed by
  `carg-publish.sh`; defaults to ''.

Now add the following to install the scripts from Github.

``` yaml
install:
  - git clone https://github.com/johnstonskj/rust-ci.git ci
```

## Scripts

* `cargo-config.sh` - determines whether it's a workspace or crate build; if
  it is a workspace it populates `$CRATES` with a comma-separated list of 
  member crates. This script is sourced by all of those that follow.
  * uses `$CARGO_FLAGS` to pass in to all commands
  * uses `$CARGO_DEBUG` when setting up the environment, including amending
    `$CARGO_FLAGS`.
* `cargo-build.sh` - execute a build, either for a single crate or for a 
  workspace.
  * if called with the single argument `--clean` will perform a Cargo
  clean command before the build.
* `cargo-command.sh` - executes a single Cargo command where the `--all`
  parameter is required for a workspace.
  * requires at least one parameter, the command to run,
  * additional parameters are passed to the cargo command (after '--').
* `cargo-lint.sh` - executes lint-like tools.
  * configured by the `$CARGO_LINTER` variable.
* `cargo-publish.sh` - publish either a crate or a workspace; in the case of
  a workspace it has to publish each crate individually and in order.
  * guarded by `$CARGO_DEPLOY`.
  
The `bin` directory also contains the `logging.sh` script that simply sets
up the internal logging functions used by the other scripts.

## Other Stuff

It's also worth adding a line with `/ci` to your `.gitignore' file
to not try and include the scripts you checked out into your repo.

## Example - Travis

An example, sort of template, Travis configuration is in the 
[examples](https://github.com/johnstonskj/rust-ci/tree/master/examples)
directory.

The following shows how the scripts may used in the builds,
specifically the build and lint steps are setup for all builds and
the publish script is integrated into the Travis deploy block.

``` yaml
# Script supports packages and workspaces
script:
- ci/bin/cargo-build.sh
- ci/bin/cargo-lint.sh

# Deployment script, this is under test
deploy:
  provider: script
  on:
    tags: true
    all_branches: true
    condition: "$TRAVIS_RUST_VERSION = stable && $TRAVIS_OS_NAME = linux && $CARGO_DEPLOY = 1"
  script: ci/bin/cargo-publish.sh
```

For a live example, see the repo [rust-financial](https://github.com/johnstonskj/rust-financial).
