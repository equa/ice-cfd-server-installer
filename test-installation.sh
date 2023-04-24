#!/bin/bash


echo -e "Running some simple test commands to assert that all bindaries can be executed"

function test_call()
{
    __name=$1
    shift 1
    eval $@ > test_${__name}.log 2>&1 && echo $__name ok || echo $__name error
}

SING_CMD="singularity exec \"$CFD_SRV_HOME/bin/openfoam.sif\"" 

test_call INST_DIR ls $CFD_SRV_HOME/bin
test_call SINGULARITY singularity --version
test_call SIF $SING_CMD setupIceCase -help
test_call USER_MPI mpirun -version
test_call CONTAINER_MPI $SING_CMD mpirun -version 
test_call NATS nats --version
test_call BROKER CloudMB -h
test_call VENV source $CFD_SRV_HOME/venv/bin/activate
test_call START_SCRIPT $CFD_SRV_HOME/bin/cfd-servers-start.sh check
test_call RUN_TEST cfd-servers-start.sh
test_call STOP_TEST cfd-servers-start.sh stop

