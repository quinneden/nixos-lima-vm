#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

RESULT=$(readlink result)

if [[ $(uname -m) == 'x64_64' ]]; then
  ARCH="x64_64"
else
  ARCH="aarch64"
fi

if [[ ! -d $RESULT ]]; then
  echo "error: symlink to nix store path not found, or store path does not exist"; exit 1
fi

mkdir -p ./img

if [[ -f ./img/lima-nixos-${ARCH}.img ]]; then
  echo "error: file exists... overwrite? [y/N]"
  read -rq || exit 1
fi

cp "${RESULT}"/nixos.img img/lima-nixos-"${ARCH}".img
chmod 644 img/lima-nixos-"${ARCH}".img
echo "copied: img/lima-nixos-${ARCH}.img"

unset ARCH RESULT
