#!/bin/sh

snowblossom_top=$(git rev-parse --show-toplevel)
cd "${snowblossom_top}"

bazel build --package_path %workspace%:snowblossom :all
