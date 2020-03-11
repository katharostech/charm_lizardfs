#!/bin/bash

set -e

# When we are a newly-elected leader
if [ "$1" = "elected" ]; then
    lucky set-status maintenance "Configuring as new leader"

    # Set the private address of the leader
    lucky leader set "leader_ip=$(lucky private-address)"

    # If the admin password has not been set yet
    if [ "$(lucky leader get admin_password)" = "" ]; then
        # Generate the admin password
        admin_password="$(lucky random --length 32)"
        # Set the password for followers
        lucky leader set "admin_password=$admin_password"
    fi

    # Update container environment variables
    lucky container env set \
        "MFSMASTER_PERSONALITY=master" \
        "MFS_MASTER_HOST="

    lucky set-status --name leader-status active

# When the leader has changed its settings
elif [ "$1" = "settings-changed" ]; then
    # Ignore leader settings changed when we are the leader
    if [ "$(lucky leader is-leader)" = "true" ]; then exit 0; fi

    lucky set-status maintenance "Updating with new leader setings"

    # Update leader ip and master personality
    master_personality="shadow"
    master_host="$(lucky leader get leader_ip)"

    # If the leader ip has not been set, exit 0 and wait for another leader-settings-changed hook
    if [ "$master_host" = "" ]; then
        lucky set-status --name leader-status waiting "Waiting for leader"
        lucky set-status active
        exit 0
    fi

    lucky set-status --name leader-status active

    # Update container environment variables
    lucky container env set \
        "MFSMASTER_PERSONALITY=$master_personality" \
        "MFSMASTER_MASTER_HOST=$master_host"
fi

lucky set-status active