#!/bin/bash

set -e

lucky set-status maintenance "Updating leader setings"

# Ignore if we are the leader. We handle leader updates in the handle-leader-elected.sh script
if [ "$(lucky leader is-leader)" = "true" ]; then exit 0; fi

# Update leader ip and master personality
master_personality="shadow"
master_host="$(lucky leader get leader_ip)"

# If the leader ip has not been set, exit 0 and wait for another leader-settings-changed hook
if [ "$master_host" = "" ]; then
    lucky set-status --name "leader_status" waiting "Waiting for leader"
    exit 0
fi

# Update container environment variables
lucky container env set \
    "MFSMASTER_PERSONALITY=$master_personality" \
    "MFSMASTER_MASTER_HOST=$master_host"

lucky set-status active