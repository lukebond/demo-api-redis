#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

# Name the ACI
acbuild --debug set-name lukebond/demo-api-redis

# Based on alpine
acbuild --debug dep add quay.io/coreos/alpine-sh

# Install nodejs
acbuild --debug run -- apk update
acbuild --debug run -- apk add nodejs

# Copy the app to the ACI & npm install
acbuild --debug copy package.json /app/demo-api-redis/package.json
acbuild --debug run -- /bin/sh -c 'cd /app/demo-api-redis && npm install'
acbuild --debug copy index.js /app/demo-api-redis/index.js

# Add a port for http traffic
acbuild --debug port add http tcp 9000

# Run nodejs with the app
acbuild --debug set-working-directory /app/demo-api-redis
acbuild --debug set-exec -- /usr/bin/node index.js

# Write the result
acbuild --debug write --overwrite demo-api-redis-latest-linux-amd64.aci
