#!/bin/sh

set -e

if [[ $(id -u) == 0 ]]
then
    echo "Do not run this as root."
    exit 1
fi

if [[ -z "$CFD_SRV_HOME" ]]
then
    echo "CFD_SRV_HOME needs to be set to existing directory."
    echo "E.g. export CFD_SRV_HOME=$HOME/cfd-server"
    exit 1
fi

INSTALL_LOG=/tmp/cfd_install_$(date +%y%m%d-%H%M%S).log
[[ -w $INSTALL_LOG ]] && rm ${INSTALL_LOG}

function run_installer()
{
    eval $1 install
    # | sed 's/\(.*\)/$(date) \1/' >>  $INSTALL_LOG
}

[[ -d "$CFD_SRV_HOME/bin" ]] || mkdir -p $CFD_SRV_HOME/bin

run_installer nats/install-nats-server.sh

run_installer cloudmb/install-cloudmb.sh

run_installer python/install-venv.sh

run_installer python/cfd/install-cfd-python.sh

run_installer python/file-server/install-file-server.sh

run_installer singularity/install-singularity.sh

run_installer openmpi/install-mpi.sh

run_installer openfoam/install-openfoam.sh

cp -v bin/cfd-servers-start.sh $CFD_SRV_HOME/bin/.

cat << EOF > $HOME/.icecfd
# Edit CFD_N_CORES as appropriate. Remove it to use all available cores.
export CFD_N_CORES=16

# Usually do not edit below this line
export CFD_SRV_HOME=$CFD_SRV_HOME
PATH=\$CFD_SRV_HOME/bin:\$PATH
export LD_LIBRARY_PATH=\$CFD_SRV_HOME/lib
export CFD_HOME=\$HOME/cfd_run
export SIF_CONTAINER=\$CFD_SRV_HOME/bin/openfoam.sif
EOF

if ! grep -q "\.icecfd" $HOME/.bashrc
then
    echo -e "\nsource \$HOME/.icecfd" >> $HOME/.bashrc
fi

cat << EOF


    Almost done, but READ THIS!
    All files should be in place and ~/.bashrc is updated.

    Now, the permissions for a Singularity executable needs to be modified
    to let Singularity containers run with some root privileges.
    To do this, execute the following two commands as *another* user that has
    sudo privileges (or as root).

    export CFD_SRV_HOME=$CFD_SRV_HOME
    $PWD/singularity/fix-singularity-suid.sh

    It is *strongly* adviced that the current user does *not* have privileges
    to execute commands using sudo.

EOF
