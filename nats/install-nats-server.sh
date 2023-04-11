#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME
VERSION=v2.9.15

cd /tmp
curl -L https://github.com/nats-io/nats-server/releases/download/$VERSION/nats-server-$VERSION-linux-amd64.tar.gz \
     -o nats-server.tgz

tar xf nats-server.tgz --strip-components=1

if [[ "$1" == install ]]
then
    $SUDO mv nats-server $INSTALL_PREFIX/bin/.
    rm nats-server.tgz
fi
