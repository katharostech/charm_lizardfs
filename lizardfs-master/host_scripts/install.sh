#!/bin/bash

set -e

lucky set-status maintenance "Installing LizardFS"

# Set container image
lucky container set image \
    "katharostech/lizardfs@sha256:255bbb81764523304de7736a9562df8a7b91c5a32d586fa93773193ee8380e6f"

# Set data volume
lucky container volume add data /var/lib/mfs

# Set host networking mode
lucky container set-network host

# Set container command
lucky container set-command -- master

lucky set-status active