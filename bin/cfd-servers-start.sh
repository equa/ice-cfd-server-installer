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

LOG_DIR=$SERVER_HOME/logs

PID_LOG=$LOG_DIR/pids


function check-components()
{
    for s in bin/nats-server bin/CloudMB bin/mpirun file-server/file-server.py
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

function stop_servers()
{
    cat $PID_LOG | xargs kill
    sleep 1
    cat $PID_LOG | xargs kill -9 > /dev/null 2>&1
}

if [[ "$1" == stop ]]
then
    set +e
    stop_servers
    exit 0
fi

port_busy $NATS_PORT

port_busy $FS_PORT

check-components

if [[ "$1" == check ]]
then
    exit 0
fi

[[ -d "$LOG_DIR" ]] || mkdir "$LOG_DIR"

echo -e "Log files and PID file are written in $LOG_DIR\n"

echo -e "Starting nats server on port $NATS_PORT"
$BIN/nats-server -p $NATS_PORT > $LOG_DIR/nats.log 2>&1 &
echo $! > $PID_LOG
echo -e "Taking a 3 s nap to let the nats server establish"

sleep 3

echo -e "Activate virtual python environment"
source $VENV/bin/activate

echo -e "Starting message broker on topic $NATS_STARTUP_TOPIC"
$BIN/CloudMB -s nats://localhost:$NATS_PORT $NATS_STARTUP_TOPIC > $LOG_DIR/cloudmb.log 2>&1 &
echo $! >> $PID_LOG

echo -e "Starting file-server on port $FS_PORT"
$CFD_SRV_HOME/file-server/file-server.py $FS_PORT > $LOG_DIR/cfd-file-server.log 2>&1 &
echo $! >> $PID_LOG

echo -e "Now, the following servers are running:"
ps -ef|grep -E "Cloud|nats|file-server.py" |grep -v grep

