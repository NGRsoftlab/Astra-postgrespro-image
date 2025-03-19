#!/usr/bin/env sh
set -ef

## Check receiving args
: "${1:?}"

## Associate program with path
divert_dir=$(printf '%s' "/run/program/divert/${1}" | tr -s '/')

## Create directory
mkdir -p "${divert_dir%/*}"

## Remove divert
dpkg-divert --divert "${divert_dir}" --rename "${1}" 2>/dev/null

## Remove program
rm -f "${divert_dir}"
