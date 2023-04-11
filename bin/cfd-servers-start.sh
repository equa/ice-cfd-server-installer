#!/bin/bash

set -e

if [[ -z "$CFD_SRV_HOME" ]]
then
    cat << EOF
    Environment variable CFD_SRV_HOME is not set. Set it like
    export CFD_SRV_HOME=/path/to/server/root
EOF
    exit 1
fi


SERVER_HOME=$CFD_SRV_HOME

FILE_SERVER_HOME=$SERVER_HOME/file-server

VENV=$SERVER_HOME/venv

BIN=$CFD_SRV_HOME/bin

NATS_PORT=4222

FS_PORT=4445

NATS_STARTUP_TOPIC=cfd.server.startup

LOG_DIR=/tmp/cfd-server-logs

PID_LOG=$LOG_DIR/pids


function check-components()
{
    for s in bin/nats-server bin/CloudMB file-server/server.py
    do
        if ! [[ -x "$CFD_SRV_HOME/$s" ]]
        then
            echo "Missing executable $CFD_SRV_HOME/$s"
            exit 1
        fi
    done
}

function port_busy()
{
    PORT=$1
    if ss -tulpn | grep -q ":$PORT\>"
    then
        echo "A server seems already to be running on port $PORT"
        exit 1
    fi
}

port_busy $NATS_PORT

port_busy $FS_PORT

check-components

[[ -d "$LOG_DIR" ]] || mkdir "$LOG_DIR"

$BIN/nats-server -p $NATS_PORT > $LOG_DIR/nats.log 2>&1 &
echo $! > $PID_LOG

echo -e "Starting nats server"
echo -e "Taking a nap to let the nats server establish"

sleep 2

echo -e "Starting message broker"
$BIN/CloudMB -s nats://localhost:$NATS_PORT $NATS_STARTUP_TOPIC > $LOG_DIR/cloudmb.log 2>&1 &
echo $! >> $PID_LOG

echo -e "Activate virtual environment"
source $VENV/bin/activate

echo -e "Starting file-server"
$CFD_SRV_HOME/file-server/server.py > $LOG_DIR/cfd-file-server.log 2>&1 &
echo $! >> $PID_LOG

