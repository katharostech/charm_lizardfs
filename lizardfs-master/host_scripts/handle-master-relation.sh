#!/bin/bash

set -e

# If we are joining a new relation
if [ "$1" = "join" ]; then
    lucky set-status maintenance "Joining Master relation"

    lucky relation set \
        "hostname=$(lucky private-address)" \
        "port=$(lucky get-config client-port)"

# If we are supposed to update our existing relations
elif [ "$1" = "update" ]; then
    lucky set-status maintenance "Updating Master relations"

    for relation_id in $(lucky relation list-ids --relation-name master); do
        lucky relation set --relation-id $relation_id \
            "hostname=$(lucky private-address)" \
            "port=$(lucky get-config client-port)"
    done
fi

lucky set-status active
