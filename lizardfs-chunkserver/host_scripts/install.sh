#!/bin/bash

set -e

lucky set-status maintenance "Installing LizardFS Chunkserver"

# Set container image
lucky container image set \
    "katharostech/lizardfs@sha256:566ef921613982bb4083a96a0749f760425314fb498dbe263b9c654e255e9002"

# Add "hard drive" for data storage
lucky container env set "MFSHDD_1=/mnt/mfshdd"

# Set volume for the data
lucky container volume add data /mnt/mfshdd

# Set host networking mode
lucky container set-network host

# Set container command
lucky container set-command -- chunkserver

# Wait on chunkserver connection
lucky set-status --name master-status blocked "Waiting for master relation"

lucky set-status active