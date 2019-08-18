#!/bin/bash
# shellcheck disable=SC2154

set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Add vars to local env
echo "PUBLIC_KEY_BUCKET=${bastion_users_bucket}" >> /etc/environment
echo "IS_BASTION=${is_bastion}" >> /etc/environment

# Sync scripts to local filesystem
BIN_DIR='/usr/local/bin'
SCRIPTS_DIR='scripts'
aws s3 sync "s3://${bastion_scripts_bucket}" "$SCRIPTS_DIR"
rsync "$SCRIPTS_DIR/${disallow_shell_script_filename}" "$BIN_DIR/"
rsync "$SCRIPTS_DIR/${sync_ssh_keys_script_filename}" "$BIN_DIR/"
rsync "$SCRIPTS_DIR/${bastion_cron_filename}" /etc/cron.d/

# Ensure correct perms
chmod +x "$BIN_DIR/${disallow_shell_script_filename}"
chmod +x "$BIN_DIR/${sync_ssh_keys_script_filename}"

/usr/local/bin/"${sync_ssh_keys_script_filename}" "${bastion_users_bucket}" "${is_bastion}"
