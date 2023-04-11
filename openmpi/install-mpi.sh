#!/usr/bin/bash
# this script is used in mpi.def and should also be run standalone on host
OPENMPI_VERSION="4.1.4"
INSTALL_PREFIX=$CFD_SRV_HOME
WM_NCOMPPROCS="16"

cd /tmp
OMPI_URL=https://download.open-mpi.org/release/open-mpi
OMPI_URL=$OMPI_URL/v${OPENMPI_VERSION%.*}/openmpi-$OPENMPI_VERSION.tar.bz2
curl $OMPI_URL | tar -xj

cd openmpi-$OPENMPI_VERSION || exit 1

./configure --prefix=$INSTALL_PREFIX \
            --enable-mpi-fortran=none \
            --enable-shared --disable-static \
            --disable-mpi-profile && \
            make -j $WM_NCOMPPROCS || exit 1

if [[ "$1" == install ]]
then
    $SUDO make install || exit 1
    cd / && rm -rf /tmp/openmpi-$OPENMPI_VERSION
fi


