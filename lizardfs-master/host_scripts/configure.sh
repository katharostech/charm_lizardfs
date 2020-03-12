#!/bin/bash

set -e

lucky set-status maintenance "Configuring Master"

# Get admin password
admin_password="$(lucky leader get admin_password)"

# Configure ports ( get port setting from kv store or generate random available port )
metalogger_port=$(lucky get-config metalogger-port)
chunkserver_port=$(lucky get-config chunkserver-port)
client_port=$(lucky get-config client-port)
tapeserver_port=$(lucky get-config tapeserver-port)

# Open ports
lucky port close --all
lucky port open $metalogger_port
lucky port open $chunkserver_port
lucky port open $client_port
lucky port open $tapeserver_port

# Set the container env
lucky container env set \
    "MFSMASTER_ADMIN_PASSWORD=$admin_password" \
    "MFSMASTER_MATOML_LISTEN_PORT=$metalogger_port" \
    "MFSMASTER_MATOCS_LISTEN_PORT=$chunkserver_port" \
    "MFSMASTER_MATOCL_LISTEN_PORT=$client_port" \
    "MFSMASTER_MATOTS_LISTEN_PORT=$tapeserver_port"

# Get master personality and host
if [ "$(lucky leader is-leader)" = "true" ]; then
    master_personality="master"
    master_host="$(lucky private-address)"
else
    master_personality="shadow"
    master_host="$(lucky leader get leader_ip)"
    
    # If the leader ip has not been set, exit 0 and wait for a leader-settings-changed hook
    if [ "$master_host" = "" ]; then
        lucky set-status --name "leader_status" waiting "Waiting for leader"
        exit 0
    fi

    # Set container env
    lucky container env set \
        "MFSMASTER_PERSONALITY=$master_personality" \
        "MFSMASTER_MASTER_HOST=$master_host"
fi

lucky set-status active