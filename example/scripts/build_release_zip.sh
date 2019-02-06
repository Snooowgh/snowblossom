#!/bin/sh
# requires: git, zip

# 1. create new release git tag --annotate 1.0.0 #(or create on github and git pull)
# 2. run this to create standalone deployment
# 3. Remember to push tags/release to github and upload the deployment

# exit if anything fails
set -eu


snowblossom_top=$(git rev-parse --show-toplevel)
version=`git describe`
name="snowblossom-${version}"
build_dir="${snowblossom_top}/.build/deployment/release"
stage_dir="${build_dir}/${name}"
config_dir="${stage_dir}/configs"
example_configs="${snowblossom_top}/example/configs"

# display environment (for debugging purposes)
env

rm -rf "${stage_dir}" "${build_dir}/${name}"

# build
cd "${snowblossom_top}"
bazel build \
    --package_path %workspace%:snowblossom \
    :SnowBlossomNode_deploy.jar \
    :SnowBlossomClient_deploy.jar \
    :SnowBlossomMiner_deploy.jar \
    :PoolMiner_deploy.jar

# create build directory from template
mkdir -p "${stage_dir}/../"
cp -r "${snowblossom_top}/example/deployment/release/template/"* "${stage_dir}"
cd "${stage_dir}"

# general logging
cp "${example_configs}/logging.properties" "${config_dir}"

# node
cp "${snowblossom_top}/bazel-bin/SnowBlossomNode_deploy.jar" "${stage_dir}/jars"
cp "${example_configs}/node.conf" "${config_dir}"

# client
cp "${snowblossom_top}/bazel-bin/SnowBlossomClient_deploy.jar" "${stage_dir}/jars"
cp "${example_configs}/client.conf" "${config_dir}"

# solo miner
#cp "${snowblossom_top}/bazel-bin/SnowBlossomMiner_deploy.jar" "${stage_dir}/jars"
#cp "${example_configs}/miner.conf" "${config_dir}"

# pool-miner
cp "${snowblossom_top}/bazel-bin/PoolMiner_deploy.jar" "${stage_dir}/jars"
cp "${example_configs}/pool-miner.conf" "${config_dir}"

cp "${example_configs}/logging.properties" "${config_dir}"

# linux systemd
cp -r "${snowblossom_top}/example/systemd" "${stage_dir}/linux/"

# zip handles line ending conversions! :D
# convert line endings to make easily windows editable
#windows_line_endings(); {
#    sed -i 's/(?<=\r)$/\r$/' "${1}"
#}
#for i in "${config_dir}"/*; do windows_line_endings '${i}'; done
#for i in "${stage_dir}/windows"/*; do windows_line_endings '${i}'; done

#cd ../

zip -rl9 "${build_dir}/${name}.zip" "${stage_dir}"
echo
echo "Release zip created at ${build_dir}/${name}.zip"
echo

#tar -czf "${build_dir}/../${name}.tar.gz" "${build_dir}"
