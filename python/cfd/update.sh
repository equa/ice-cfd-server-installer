#!/bin/bash

cd $(realpath $(dirname $0))

tar --transform='s/requirements/pip-requirements/' \
    --transform='s/python\///' \
    -xvf python.tgz python/requirements.txt

[[ $? == 0 ]] || { echo "Error extracting from python.tgz"; exit 1; }

cat << EOF

 Extracted requirements file from archive,

 python.tgz is not updated automatically
 you need to copy it from SVN

EOF
exit 0
