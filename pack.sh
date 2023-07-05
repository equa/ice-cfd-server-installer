#!/bin/bash

git branch --show-current > revision
git rev-parse HEAD >> revision
tar czf ice-cfd-server-installer.tgz * --transform 's,^,ice-cfd-server-installer/,' 
