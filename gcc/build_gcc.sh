#!/bin/bash

# This script is meant to make it easy to build GCC using a Docker container.

# Run this from the same directory as gcc source directory
# Recommended to clone GCC with:
#    git clone --depth 1 -b "releases/gcc-11.3.0" git://gcc.gnu.org/git/gcc.git

THIS=$(readlink -e $0)
USER_ID=`id -u`
GROUP_ID=`id -g`
VERSION=11.3.0

mkdir -p gcc-$VERSION

docker run -v $(pwd):/src -w /src -u root -t debian:test /bin/bash /src/docker.sh $VERSION

cp -v $THIS gcc-$VERSION/
tar cv gcc-$VERSION | xz -T0 -c | split --bytes=90MB - gcc-$VERSION.tar.xz.
