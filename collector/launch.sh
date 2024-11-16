#!/usr/bin/env sh

#### Check required Environment settings

if [[ -z "${STRATUM_BASE_URL}" ]]; then
  echo Environment variable STRATUM_BASE_URL must be set >&2
  exit 1
fi

if [[ -z "${STRATUM_TOKEN}" ]]; then
  echo Environment variable STRATUM_TOKEN must be set >&2
  exit 1
fi

if [[ -z "${AUTHORIZED_KEY}" ]]; then
  echo Environment variable AUTHORIZED_KEY must be set >&2
  exit 1
fi

if [[ -z "${SSH_ED25519_KEY}" ]]; then
  echo Environment variable SSH_ED25519_KEY must be set >&2
  exit 1
fi

if [[ -z "${SSH_RSA_KEY}" ]]; then
  echo Environment variable SSH_ED25519_KEY must be set >&2
  exit 1
fi

if [[ -z "${SSH_USERNAME}" ]]; then
  echo Environment variable SSH_USERNAME must be set >&2
  exit 1
fi

#### Create User
if id -u "$SSH_USERNAME" >/dev/null 2>&1; then
  echo 'Welcome back...'
else
  echo 'Setting up for the first time...'
  adduser --disabled-password --gecos "" --ingroup upload $SSH_USERNAME
  usermod -p '*' $SSH_USERNAME
fi

#### SSH Server Setup
echo "$SSH_ED25519_KEY" > /etc/ssh/ssh_host_ed25519_key
echo "$SSH_RSA_KEY" > /etc/ssh/ssh_host_rsa_key
chmod 600 /etc/ssh/ssh_host_ed25519_key || true
chmod 600 /etc/ssh/ssh_host_rsa_key || true

#### Setup SSH user / keys
mkdir -p /home/$SSH_USERNAME/.ssh
echo "$AUTHORIZED_KEY" > /home/$SSH_USERNAME/.ssh/authorized_keys

#### Start SSH Server
if [[ ! -z DEBUG_MODE ]]; then
  /usr/sbin/sshd -D &
else
  /usr/sbin/sshd -dd &
fi

#### Watch for and convert pdf files
inotifywait -m /input -e close_write -e moved_to |
  while read path action file; do
    if [[ "$file" =~ .*pdf$ ]]; then # Does the file end with .pdf?
      curl -XPOST -H 'Accept: application/json' -H 'Authorization: Bearer '"$STRATUM_TOKEN"'' -F 'document[file]=@/input/'"$file"'' $STRATUM_BASE_URL/api/v1/documents
    fi

    rm /input/$file

    echo "Completed processing: /input/$file"
  done
