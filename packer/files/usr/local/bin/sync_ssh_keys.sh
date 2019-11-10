#!/bin/bash
# shellcheck disable=SC2174

# Check environment vars
PUBLIC_KEY_BUCKET="${PUBLIC_KEY_BUCKET:-$1}"

# Sync the keys to the local filesystem
PUBLIC_KEY_DIR='public_ssh_keys'
mkdir -m 700 -p "${PUBLIC_KEY_DIR}"
if [[ -n "${PUBLIC_KEY_BUCKET}" ]]; then
  echo "${PUBLIC_KEY_BUCKET} is set as the PUBLIC_KEY_BUCKET"
else
  echo "${PUBLIC_KEY_BUCKET} not set"
  exit 1
fi
aws s3 sync "s3://${PUBLIC_KEY_BUCKET}" "${PUBLIC_KEY_DIR}"

for FILENAME in "${PUBLIC_KEY_DIR}"/*.pub; do
  [[ -e "${FILENAME}" ]] || { echo "No public keys found" && exit 1; }  # handle the case of no *.pub files

  # Create a user for each key
  USERNAME=$(echo "${FILENAME}" | awk -F"${PUBLIC_KEY_DIR}/" '{print $2}' | awk -F'.pub' '{print $1}')
  adduser --disabled-password --gecos "" "${USERNAME}" || true

  # Add public ssh key to authorized keys
  SSH_DIR="/home/${USERNAME}/.ssh"
  mkdir -m 700 -p "${SSH_DIR}"
  cat "${FILENAME}" > "${SSH_DIR}/authorized_keys"
  chmod 0600 "${SSH_DIR}/authorized_keys"
  chown -R "${USERNAME}" "${SSH_DIR}/"
done
