#!/bin/bash

# exit if anything fails
set -eu

snowblossom_top=$(git rev-parse --show-toplevel)
build_dir="${snowblossom_top}/.build/android"
cd "${snowblossom_top}"

bazel build --package_path %workspace%:snowblossom :SnowBlossomClient_deploy.jar

rm -f "${build_dir}/SnowBlossomClient_android.jar"
rm -rf "${build_dir}/jar"
mkdir -p "${build_dir}/jar"
cd "${build_dir}"

cd "jar"
jar xvf "${snowblossom_top}/bazel-bin/SnowBlossomClient_deploy.jar"
rm module-info.class
rm librocksdbjni*

jar cvf ../SnowBlossomClient_android.jar .
