#!/bin/bash

set -e 

if [ "$1" = "join" ]; then
    lucky set-status --name master-status maintenance "Connecting to master"

    master_host="$(lucky relation get --app hostname)"
    master_port="$(lucky relation get --app client-port)"

    if [ "$master_host" != "" -a "$master_port" != "" ]; then
        lucky container env set \
            "MASTER_HOST=$master_host" \
            "MASTER_PORT=$master_port"

        lucky set-status --name master-status active
    fi

elif [ "$1" = "update" ]; then
    lucky set-status --name master-status maintenance "Updating master connection"

    master_host="$(lucky relation get --app hostname)"
    master_port="$(lucky relation get --app client-port)"

    if [ "$master_host" != "" -a "$master_port" != "" ]; then
        lucky container env set \
            "MASTER_HOST=$master_host" \
            "MASTER_PORT=$master_port"

        lucky set-status --name master-status active
    fi

elif [ "$1" = "leave" ]; then
    lucky set-status --name master-status maintenance "Leaving master relation"

    # Remove container env vars
    lucky container env set "MASTER_HOST=" "MASTER_PORT="

    lucky set-status --name master-status active
fi