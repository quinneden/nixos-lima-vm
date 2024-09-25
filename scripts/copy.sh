#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

RESULT=$(readlink result)

if [[ $(uname -m) == 'x64_64' ]]; then
  ARCH="x64_64"
else
  ARCH="aarch64"
fi

confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac
  done
}

if [[ ! -d $RESULT ]]; then
  echo "error: symlink to nix store path not found, or store path does not exist"; exit 1
fi

mkdir -p ./img

if [[ -f ./img/lima-nixos-${ARCH}.img ]]; then
  echo "warning: file exists, script will overwrite..."
  sleep 0.5
  confirm "" || exit 1
fi

cp "${RESULT}"/nixos.img img/lima-nixos-"${ARCH}".img
chmod 644 img/lima-nixos-"${ARCH}".img
echo "copied: img/lima-nixos-${ARCH}.img"

unset ARCH RESULT
