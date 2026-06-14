#!/usr/bin/env bash
set -euo pipefail

DEPLOY_USER=${DEPLOY_USER:-deploy}
SSH_KEY=${SSH_KEY:-~/.ssh/deploy}
SERVER=${SERVER:-}
REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

IPS=$(cd "$REPO_ROOT/terraform" && terraform output -json server_ips)

if [ -n "$SERVER" ]; then
    IP=$(echo "$IPS" | jq -r --arg s "$SERVER" '.[$s] // empty')
    if [ -z "$IP" ]; then
        echo "Error: server \"$SERVER\" not found. Available: $(echo "$IPS" | jq -r 'keys | join(", ")')"
        exit 1
    fi
else
    IP=$(echo "$IPS" | jq -r '.[keys[0]] // empty')
    if [ -z "$IP" ]; then
        echo "Error: no servers found"
        exit 1
    fi
fi

ssh -i "$SSH_KEY" "$DEPLOY_USER"@"$IP"
