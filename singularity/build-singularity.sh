#!/bin/bash

set -e

INSTALL_PREFIX=${INSTALL_PREFIX:-/usr/local}
SGTY_VERSION=3.11.1
SCRIPT_DIR=$(realpath $(dirname $0))

export GOPATH=${HOME}/go
if [[ -d "$GOPATH" && -d "${INSTALL_PREFIX}/go/bin" ]]
then
    echo "go is available"
else
    $SCRIPT_DIR/install-go.sh
fi

export PATH=${INSTALL_PREFIX}/go/bin:${PATH}:${GOPATH}/bin

cd /tmp


[[ -d singularity ]] || git clone https://github.com/sylabs/singularity.git
cd singularity
git checkout v$SGTY_VERSION
git submodule update --init

[[ -d builddir ]] && rm -rf builddir
mkdir builddir

./mconfig --prefix=${INSTALL_PREFIX} && make -C ./builddir

if [[ "$1" == install ]]
then
    $SUDO make -C ./builddir install
    if [[ "$SUDO" == sudo ]]
    then
        $SUDO ldconfig
    fi
    cd / && rm -rf /tmp/singularity
fi
