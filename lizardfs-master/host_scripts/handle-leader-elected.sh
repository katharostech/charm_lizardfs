#!/bin/bash

set -e

lucky set-status maintenance "Configuring as new leader"

# Set the private address of the leader
lucky leader set "leader_ip=$(lucky private-address)"

lucky set-status