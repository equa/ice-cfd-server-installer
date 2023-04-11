#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME

cd $(dirname $(realpath $0))

[[ -f ./CloudMB ]] || { echo "CloudMB executable not here"; exit 1; }

if [[ "$1" == install ]]
then
    [[ -d  $INSTALL_PREFIX/bin ]] || $SUDO mkdir $INSTALL_PREFIX/bin
    $SUDO cp CloudMB $INSTALL_PREFIX/bin/.
fi
