#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME

cd $(dirname $(realpath $0))

[[ -f ./python.tgz ]] || { echo "python.tgz not here"; exit 1; }

if [[ "$1" == install ]]
then
    $SUDO tar xf python.tgz --strip-components=1 -C $INSTALL_PREFIX/bin/
fi
