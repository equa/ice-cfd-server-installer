#!/bin/sh

set -ex

if [[ $(id -u) == 0 ]]
then
    echo "Do not run this as root."
    exit 1
fi

if [[ -z "$CFD_SRV_HOME" ]]
then
    echo "INSTALL_RREFIX needs to be set to existing directory."
    exit 1
fi

nats/install-nats-server.sh install

cloudmb/install-cloudmb.sh install

python/install-venv.sh install

python/cfd/install-cfd-python.sh install

python/file-server/install-file-server.sh install

singularity/install-singularity.sh install

openmpi/install-mpi.sh install

openfoam/install-openfoam.sh install

cp -v bin/cfd-servers-start.sh $CFD_SRV_HOME/bin/.
