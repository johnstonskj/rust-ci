# rust-ci

This repo contains a set of CI scripts (tested with Travis) for 
Rust projects that can be integrated into `.travis.yml` 
configuration.

## Configuration

Add the following block to your configuration.

``` yaml
env:
  global:
  - CARGO_DEBUG=1
  - CARGO_FLAGS=--verbose
  - CARGO_LINTER=fmt
  - CARGO_DEPLOY=1
```

* `CARGO_DEBUG` - set to 1 to enable debugging (sets RUST_BACKTRACE,
  RUST_LOG, CARGO_FLAGS, and enables the script's `debug` function.
* `CARGO_FLAGS` - any flags you want to pass into any/all Cargo
  commands.
* `CARGO_LINTER`- a comma separated list of cargo commands you want
  to run as linters. 
* `CARGO_DEPLOY`- set to 1 to enable the deployments executed by
  `carg-publish.sh`

Now add the following to install the scripts from Github.

``` yaml
install:
  - git clone https://github.com/johnstonskj/rust-ci.git ci
```

It's also worth adding a line with `/ci` to your `.gitignore' file
to not try and include the scripts you checked out into your repo.

## Example

The following example shows how the scripts are used in the builds,
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

For an example, see the repo [rust-financial](https://github.com/johnstonskj/rust-financial).
