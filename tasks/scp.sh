#!/usr/bin/env bash

# move a file from a source to a destination
# some simple support is in place for wildcards
cat /var/version && echo ""
set -eu

# Check if necessary environment variables are set
if [ -z "$PUSH_PULL" ] || [ -z "$HOST_PRIVATE_KEY" ] || [ -z "$HOST_USERNAME" ]; then
    echo "Error: Missing required environment variables."
    exit 1
fi

echo "${HOST_PRIVATE_KEY}" > /tmp/scp-key.pem
chmod 600 /tmp/scp-key.pem

# Set up SSH options
SSH_OPTIONS="-o StrictHostKeyChecking=no"
#export HOST_FQDN="$HOST_FQDN"
#export HOST_PATH="$HOST_PATH"
# Determine direction of transfer based on PUSH_PULL
if [ "$PUSH_PULL" == "push" ]; then
    scp -i /tmp/scp-key.pem "${SSH_OPTIONS}" $LOCAL_PATH "${HOST_USERNAME}@${HOST_FQDN}:${HOST_PATH}"
elif [ "$PUSH_PULL" == "pull" ]; then
# so if we want to pull a glob, we may need to `ls` that glob and just get the first matching file?
    file_to_pull=$(ssh -i /tmp/scp-key.pem "${SSH_OPTIONS}" "${HOST_USERNAME}@${HOST_FQDN}" "ls -1dr ${HOST_PATH} | head -1")
    scp -i /tmp/scp-key.pem "${SSH_OPTIONS}" "${HOST_USERNAME}@${HOST_FQDN}:${file_to_pull}" "${LOCAL_PATH}"
else
    echo "Error: PUSH_PULL variable must be 'push' or 'pull'."
    exit 1
fi