#!/bin/bash

# This script is meant to make it easy to rebuild Boost using the linux-fresh
# yuzu-emu container.

# Run this from within boost_[version] directory
# Downloaded source archive must come from https://www.boost.org/

THIS=$(readlink -e $0)
USER_ID=`id -u`
GROUP_ID=`id -g`
BASE_NAME=`readlink -e $(pwd) | sed 's/.*\///g'`

docker run -v $(pwd):/boost -w /boost -u root -t yuzuemu/build-environments:linux-fresh /bin/bash /boost/bootstrap.sh
docker run -v $(pwd):/boost -w /boost -u root -t yuzuemu/build-environments:linux-fresh /boost/b2
docker run -v $(pwd):/boost -w /boost -u root -t yuzuemu/build-environments:linux-fresh /bin/chown -R ${USER_ID}:${GROUP_ID} .

mkdir -pv $BASE_NAME/
mkdir -pv $BASE_NAME/include/
mv -v boost $BASE_NAME/include/
mv -v stage/lib $BASE_NAME/
cp -v $THIS $BASE_NAME/

tar cv $BASE_NAME | xz -c > $BASE_NAME.tar.xz

if [ -e $BASE_NAME.tar.xz ]; then
    echo "Boost package can be found at $(readlink -e $BASE_NAME.tar.xz)"
fi

