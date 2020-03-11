#!/bin/bash

set -e

# If we are joining a new relation
if [ "$1" = "join" ]; then
    lucky set-status maintenance "Joining Chunkserver relation"

    lucky relation set --app \
        "hostname=$(lucky private-address)" \
        "port=$(lucky get-config chunkserver-port)"

# If we are supposed to update our existing relations
elif [ "$1" = "update" ]; then
    lucky set-status maintenance "Updating Chunkserver relations"

    for relation_id in $(lucky relation list-ids --relation-name chunkserver); do
        lucky relation set --app --relation-id $relation_id \
            "hostname=$(lucky private-address)" \
            "port=$(lucky get-config chunkserver-port)"
    done
fi

lucky set-status active
