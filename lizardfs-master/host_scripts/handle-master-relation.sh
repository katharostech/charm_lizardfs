#!/bin/bash

set -e

# If we are joining a new relation
if [ "$1" = "join" ]; then
    lucky set-status maintenance "Joining Master relation"

    lucky relation set \
        "host=$(lucky private-address)" \
        "port=$(lucky kv get client_port)"
fi

lucky set-status active
