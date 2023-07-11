#!/bin/bash

git branch --show-current > revision
git rev-parse HEAD >> revision
rm ice-cfd-server-installer.tgz
tar czf ice-cfd-server-installer.tgz * --transform 's,^,ice-cfd-server-installer/,' 
