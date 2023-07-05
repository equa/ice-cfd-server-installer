#!/bin/bash

set -e

CWD=$(dirname $(realpath $0))

cd /tmp

if [[ -d file-server ]]
then
    (
        cd file-server
        git pull
    )
else
    git clone --depth 1 -b master https://github.com/niklasw/simple-file-proxy.git file-server
fi
cd ./file-server
git archive --format=tar --prefix=./ --output=$CWD/file-server.tar HEAD

cd $CWD
tar --transform='s/requirements/pip-requirements/' \
    -xvf file-server.tar ./requirements.txt

[[ $? == 0 ]] || { echo "Error extracting from file-server.tgz"; exit 1; }

