#!/bin/sh

set -ex

if [[ -z "$INSTALL_PREFIX" ]]
then
    echo "INSTALL_RREFIX needs to be set to existing directory."
    exit 1
fi

cloudmb/install-cloudmb.sh install

python/setup-venv.sh install

python/cfd/install-cfd-python.sh install

python/file-server/install-file-server.sh install

singularity/build-singularity.sh install

openmpi/build-mpi.sh install

openfoam/install-openfoam.sh install




