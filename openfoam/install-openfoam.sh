#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME

cd $(dirname $(realpath $0))

[[ -f ./openfoam.sif ]] || { echo "openfoam.sif container not here"; exit 1; }

if [[ "$1" == install ]]
then
    $SUDO cp openfoam.sif $INSTALL_PREFIX/bin
fi
