#!/bin/bash

# Export environment variables
export GITHUB_USER=${GITHUB_USER}
export GITHUB_TOKEN=${GITHUB_TOKEN}

exec /usr/bin/shiny-server
