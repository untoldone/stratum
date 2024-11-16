#!/usr/bin/env bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $PARENT_PATH

export STRATUM_BASE_URL=http://host.docker.internal:3000
export SSH_ED25519_KEY="$(cat ./keys/ssh_host_ed25519_key)"
export SSH_RSA_KEY="$(cat ./keys/ssh_host_rsa_key)"
export AUTHORIZED_KEY="$(cat ./keys/authorized_keys)"
export STRATUM_TOKEN="$(cat ./keys/stratum_token)"

docker compose up --build --no-log-prefix
