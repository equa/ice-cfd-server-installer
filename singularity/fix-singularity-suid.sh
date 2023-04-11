#!/bin/bash

INSTALL_PREFIX=$CFD_SRV_HOME

SUID_FILE=$INSTALL_PREFIX/libexec/singularity/bin/starter-suid

[[ -f "$SUID_FILE" ]] || { echo "Missing file $SUID_FILE"; exit 1; }

cat << EOF


NOTE: This script requires root priviliges by invoking sudo. A singularity
start-up file will be given permission to execute as root. The executable
in question is "$SUID_FILE".

EOF

read -p "Continue? (Otherwise press Ctrl-C)"

sudo chmod u+s $SUID_FILE

echo "Done:"
ls -l $SUID_FILE

