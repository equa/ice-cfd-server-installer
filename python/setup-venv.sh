#!/bin/bash

set -ex

INSTALL_PREFIX=${INSTALL_PREFIX:-/usr/local}

SCRIPT_PATH=$(dirname $(realpath $0))

cd $INSTALL_PREFIX

echo "Setting up virtual environment $INSTALL_PREFIX/venv"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip

for f in $(find $SCRIPT_PATH -name pip-requirements.txt)
do
    echo "Installing python requirements from $f"
    pip install -r "$f"
done




