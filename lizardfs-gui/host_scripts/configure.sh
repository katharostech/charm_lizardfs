#!/bin/bash

set -e

lucky set-status maintenance "Configuring LizardFS"

# Configure port
port="$(lucky get-config port)"
lucky container port remove --all
lucky container port add "$port:80"
lucky port close --all
lucky port open $port

# Set container command
lucky container set-command -- cgiserver

lucky set-status active