#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME

cd $(dirname $(realpath $0))

[[ -f ./file-server.tar ]] || { echo "file-server.tar not here"; exit 1; }

if [[ "$1" == install ]]
then
    [[ -d $INSTALL_PREFIX/file-server ]] || mkdir $INSTALL_PREFIX/file-server
    $SUDO tar xf file-server.tar -C $INSTALL_PREFIX/file-server/
fi
