#!/usr/bin/env bash
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -d /tmp/dashlane-cli ]; then
  git clone https://github.com/Dashlane/dashlane-cli /tmp/dashlane-cli
fi

(cd /tmp/dashlane-cli && nix run nixpkgs#node2nix -- -18 --pkg-name nodejs_18 --development -e "${SCRIPT_DIR}/../node2nix/node-env.nix" -i "${SCRIPT_DIR}/../node2nix/node-packages.json" -c "${SCRIPT_DIR}/../node2nix/default.nix")