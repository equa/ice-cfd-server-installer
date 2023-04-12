#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME

cd $(dirname $(realpath $0))

[[ -f ./openfoam.sif ]] || { echo "openfoam.sif container not here"; exit 1; }

if [ -f $INSTALL_PREFIX/bin/openfoam.sif ]
then
    read -p "OpenFOAM container seems to be installed already. Re-install?" __ANS
    [[ "$__ANS" == y ]] || exit 0
fi

if [[ "$1" == install ]]
then
    $SUDO cp openfoam.sif $INSTALL_PREFIX/bin
fi
