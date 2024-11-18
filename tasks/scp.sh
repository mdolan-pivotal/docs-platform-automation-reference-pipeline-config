#!/usr/bin/env bash

#move a file from a source to a destination

cat /var/version && echo ""
set -eux

timestamp="$(date '+%Y%m%d.%-H%M.%S+%Z')"
export timestamp

# Check if necessary environment variables are set
if [ -z "$PUSH_PULL" ] || [ -z "$HOST_PRIVATE_KEY" ] || [ -z "$HOST_USERNAME" ]; then
    echo "Error: Missing required environment variables."
    exit 1
fi

echo "${HOST_PRIVATE_KEY}" > /tmp/scp-key.pem
chmod 600 /tmp/scp-key.pem

# Set up SSH options
SSH_OPTIONS="-i /tmp/scp-key.pem -o StrictHostKeyChecking=no"

# Determine direction of transfer based on PUSH_PULL
if [ "$PUSH_PULL" == "push" ]; then
    scp "${SSH_OPTIONS} ${LOCAL_PATH} ${HOST_USERNAME}@${HOST_FQDN}:${HOST_PATH}"
elif [ "$PUSH_PULL" == "pull" ]; then
    scp "${SSH_OPTIONS} ${HOST_USERNAME}@${HOST_FQDN}:${HOST_PATH} ${LOCAL_PATH}"
else
    echo "Error: PUSH_PULL variable must be 'push' or 'pull'."
    exit 1
fi