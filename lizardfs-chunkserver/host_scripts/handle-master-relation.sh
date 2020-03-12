#!/bin/bash

set -e 

if [ "$1" = "join" ]; then
    lucky set-status --name master-status maintenance "Connecting to master"

    master_host="$(lucky relation get --app hostname)"
    master_port="$(lucky relation get --app chunkserver-port)"

    if [ "$master_host" != "" -a "$master_port" != "" ]; then
        lucky container env set \
            "MFSCHUNKSERVER_MASTER_HOST=$master_host" \
            "MFSCHUNKSERVER_MASTER_PORT=$master_port"

        lucky set-status --name master-status active
    fi

elif [ "$1" = "update" ]; then
    lucky set-status --name master-status maintenance "Updating master connection"

    master_host="$(lucky relation get --app hostname)"
    master_port="$(lucky relation get --app chunkserver-port)"

    if [ "$master_host" != "" -a "$master_port" != "" ]; then
        lucky container env set \
            "MFSCHUNKSERVER_MASTER_HOST=$master_host" \
            "MFSCHUNKSERVER_MASTER_PORT=$master_port"

        lucky set-status --name master-status active
    fi
fi