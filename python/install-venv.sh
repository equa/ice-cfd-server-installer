#!/bin/bash

set -e

INSTALL_PREFIX=$CFD_SRV_HOME

SCRIPT_PATH=$(dirname $(realpath $0))

if [ -d $INSTALL_PREFIX/venv ]
then
    read -p "A virtual python env exists already. Re-install?" __ANS
    [[ "$__ANS" == y ]] || exit 0
    rm -rf $INSTALL_PREFIX/venv
fi

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




