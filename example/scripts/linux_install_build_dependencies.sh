#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script requires root!"
   exit 1
fi

# exit upon any error
set -eu

# install openjdk-8-jdk and bazel
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/snowblossom-bazel.list
wget -qO - https://bazel.build/bazel-release.pub.gpg | apt-key add -
apt-get update
apt-get -yq install git openjdk-8-jdk-headless bazel git zip
