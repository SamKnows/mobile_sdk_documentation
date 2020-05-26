#!/bin/bash -x

# Create the slate documentation

git submodule update --init --recursive
git config push.default simple
cd mobile_sdk_documentation_published
git checkout develop
git status
cd -

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export JAVA_HOME=//usr/lib/jvm/java-1.8.0/
export ANDROID_HOME=/opt/android/sdk

docker build -t samknows-mobile-sdk-doc . | grep 'Successfully built' | sed 's/Successfully built //' | xargs -I % sh -c './copy.sh %'

./mobile_sdk_documentation_published/publish.sh "$1"
