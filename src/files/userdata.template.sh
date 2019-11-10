#!/bin/bash
# shellcheck disable=SC2154

set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Add vars to local env
echo "PUBLIC_KEY_BUCKET=${bastion_users_bucket}" >> /etc/environment

# Initiate ssh key sync
/usr/local/bin/sync_ssh_keys.sh "${bastion_users_bucket}"
