#!/bin/bash

set -e

# If we are joining a new relation
if [ "$1" = "join" ]; then
    lucky set-status maintenance "Joining Master relation"

    if [ "$(lucky leader is-leader)" = "true" ]; then
        lucky relation set --app \
            "hostname=$(lucky private-address)" \
            "port=$(lucky get-config client-port)"
    fi

# If we are supposed to update our existing relations
elif [ "$1" = "update" ]; then
    lucky set-status maintenance "Updating Master relations"

    if [ "$(lucky leader is-leader)" = "true" ]; then
        for relation_id in $(lucky relation list-ids --relation-name master); do
            lucky relation set --app --relation-id $relation_id \
                "hostname=$(lucky private-address)" \
                "port=$(lucky get-config client-port)"
        done
    fi
fi

lucky set-status active
