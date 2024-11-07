#!/usr/bin/env bash

#move a file from a source to a destination

cat /var/version && echo ""
set -eu

# Check if necessary environment variables are set
if [ -z "$PUSH_PULL" ] || [ -z "$SSH_HOST_PRIVATE_KEY" ] || [ -z "$SSH_HOST_USERNAME" ]; then
    echo "Error: Missing required environment variables."
    exit 1
fi

# Define host and file paths
LOCAL_PATH="scp-files"   # Replace with actual local path

# Set up SSH options
SSH_OPTIONS="-i $HOST_PRIVATE_KEY -o StrictHostKeyChecking=no"

# Determine direction of transfer based on PUSH_PULL
if [ "$PUSH_PULL" == "push" ]; then
    scp $SSH_OPTIONS "$LOCAL_PATH" "$HOST_USERNAME@$HOST_FQDN:$HOST_PATH"
elif [ "$PUSH_PULL" == "pull" ]; then
    scp $SSH_OPTIONS "$HOST_USERNAME@$HOST_FQDN:$HOST_PATH" "$LOCAL_PATH"
else
    echo "Error: PUSH_PULL variable must be 'push' or 'pull'."
    exit 1
fi