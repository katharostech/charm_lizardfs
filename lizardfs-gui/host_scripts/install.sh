#!/bin/bash

set -e

lucky set-status maintenance "Installing LizardFS"

# Set container image
lucky container image set \
    "katharostech/lizardfs@sha256:255bbb81764523304de7736a9562df8a7b91c5a32d586fa93773193ee8380e6f"

lucky set-status active