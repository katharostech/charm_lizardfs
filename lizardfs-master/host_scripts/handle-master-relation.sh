#!/bin/bash

set -e

# If we are joining a new relation
if [ "$1" = "join" ]; then
    lucky set-status maintenance "Connecting to client"

    if [ "$(lucky leader is-leader)" = "true" ]; then
        lucky relation set --app \
            "hostname=$(lucky private-address)" \
            "metalogger-port=$(lucky get-config metalogger-port)" \
            "chunkserver-port=$(lucky get-config chunkserver-port)" \
            "client-port=$(lucky get-config client-port)" \
            "tapeserver-port=$(lucky get-config tapeserver-port)"
    fi

# If we are supposed to update our existing relations
elif [ "$1" = "update" ]; then
    lucky set-status maintenance "Updating client connections"

    if [ "$(lucky leader is-leader)" = "true" ]; then
        for relation_id in $(lucky relation list-ids --relation-name master); do
            lucky relation set --app \
                "hostname=$(lucky private-address)" \
                "metalogger-port=$(lucky get-config metalogger-port)" \
                "chunkserver-port=$(lucky get-config chunkserver-port)" \
                "client-port=$(lucky get-config client-port)" \
                "tapeserver-port=$(lucky get-config tapeserver-port)"
        done
    fi
fi

lucky set-status active
