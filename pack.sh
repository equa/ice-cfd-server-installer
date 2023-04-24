#!/bin/bash

rm ice-cfd-resources.tgz
git branch --show-current > revision
git rev-parse HEAD >> revision
tar czf ice-cfd-resources.tgz * --transform 's,^,ice-cfd-installer/,' 
