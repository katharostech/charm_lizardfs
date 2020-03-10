#!/bin/bash

set -e

lucky set-status maintenance "Configuring LizardFS"

# Set admin password
admin_password="$(lucky leader get admin_password)"

# If we are the leader and the password has not been set yet
if [ "$(lucky leader is-leader)" = "true" -a "$admin_password" = "" ]; then
    # Generate the admin password
    admin_password="$(lucky random --length 32)"
    # Set the password for followers
    lucky leader set "admin_password=$admin_password"
fi

# Configure ports ( get port setting from kv store or generate random available port )
metalogger_port=$(lucky kv get metalogger_port)
metalogger_port=${metalogger_port:-$(lucky random --available-port)}
lucky kv set "metalogger_port=$metalogger_port"

chunkserver_port=$(lucky kv get chunkserver_port)
chunkserver_port=${chunkserver_port:-$(lucky random --available-port)}
lucky kv set "chunkserver_port=$chunkserver_port"

client_port=$(lucky kv get client_port)
client_port=${client_port:-$(lucky random --available-port)}
lucky kv set "client_port=$client_port"

tapeserver_port=$(lucky kv get tapeserver_port)
tapeserver_port=${tapeserver_port:-$(lucky random --available-port)}
lucky kv set "tapeserver_port=$tapeserver_port"

# Set the container env
lucky container env set \
    "MFSMASTER_ADMIN_PASSWORD=$admin_password" \
    "MFSMASTER_MATOML_LISTEN_PORT=$metalogger_port" \
    "MFSMASTER_MATOCS_LISTEN_PORT=$chunkserver_port" \
    "MFSMASTER_MATOCL_LISTEN_PORT=$client_port" \
    "MFSMASTER_MATOCL_LISTEN_PORT=$tapeserver_port"

# Set the command
lucky container set-command -- master

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