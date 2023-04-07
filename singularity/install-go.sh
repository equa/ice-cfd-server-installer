#!/bin/bash

set -e

INSTALL_PREFIX=${INSTALL_PREFIX:-/usr/local}
GO_VERSION=${GO_VERSION:-1.19.6}

cd /tmp

if [[ -d $INSTALL_PREFIX/go ]]
then
    echo "go is already installed in $INSTALL_PREFIX/go. Skipping."
else
    echo "Download and unpack go version $GO_VERSION to $INSTALL_PREFIX"
    export VERSION=$GO_VERSION OS=linux ARCH=amd64 && \
        wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
        $SUDO tar -C ${INSTALL_PREFIX} -xzf go$VERSION.$OS-$ARCH.tar.gz && \
        rm go$VERSION.$OS-$ARCH.tar.gz
    
    echo 'Add the following two variables to ~/.bashrc to make persistent:'
    echo "export GOPATH=${HOME}/go"
    echo "export PATH=${INSTALL_PREFIX}/go/bin:\${PATH}:\${GOPATH}/bin"
fi

export GOPATH=${HOME}/go
export PATH=${INSTALL_PREFIX}/go/bin:${PATH}:${GOPATH}/bin


