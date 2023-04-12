#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME
SGTY_VERSION=3.11.1
SCRIPT_DIR=$(realpath $(dirname $0))

if [ -x $INSTALL_PREFIX/bin/singularity ]
then
    read -p "Open singularity seems to be installed already. Re-install?" __ANS
    [[ "$__ANS" == y ]] || exit 0
fi

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
