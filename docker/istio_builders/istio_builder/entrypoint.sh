#!/bin/bash

set -o errexit

set -o nounset

if [[ -n ${USER:-} ]]; then
  # write a fake user entry with settings matching the host user possible
  echo "${USER}:!:${UID}:${GID}::${HOME}:/bin/bash" >> /etc/passwd
fi

if [[ -n ${ROOT_SETUP:-} ]]; then
  # Will run the 'root_setup' script as root, and the command use USERS
  ${ROOT_SETUP} && \
    su -c "$@" ${USER}
else
  # Will run as root unless docker is started with -u UID
  exec "$@"
fi