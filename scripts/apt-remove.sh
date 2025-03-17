#!/usr/bin/env sh
set -ef

apt purge -y --allow-remove-essential "$@"
exec apt autopurge -y
