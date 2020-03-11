#!/bin/bash

set -e

lucky set-status maintenance "Installing LizardFS"

# Set container image
lucky container image set \
    "katharostech/lizardfs@sha256:566ef921613982bb4083a96a0749f760425314fb498dbe263b9c654e255e9002"

lucky set-status active