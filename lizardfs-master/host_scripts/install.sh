#!/bin/bash

set -e

lucky set-status maintenance "Installing LizardFS Master"

# Set container image
lucky container image set \
    "katharostech/lizardfs@sha256:566ef921613982bb4083a96a0749f760425314fb498dbe263b9c654e255e9002"

# Set data volume
lucky container volume add data /var/lib/mfs

# Set host networking mode
lucky container set-network host

# Set container command
lucky container set-command -- master

lucky set-status active