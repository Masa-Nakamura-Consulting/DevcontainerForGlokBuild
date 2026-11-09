#!/usr/bin/env bash
set -euo pipefail

# Fine-grained token only. Do not use SSH keys.
if [[ -n "${GH_TOKEN:-}" ]]; then
  #printf '%s\n' "$GH_TOKEN" | gh auth login --with-token
  gh auth setup-git
  echo "gh authenticated via GH_TOKEN"
else
  echo "WARN: GH_TOKEN is not set. Set the environment variable on the remote host and recreate the container." >&2
fi

git config --global user.name "${GIT_AUTHOR_NAME:-grok-devcontainer}"
git config --global user.email "${GIT_AUTHOR_EMAIL:-grok-devcontainer@local}"
git config --global --add safe.directory "*"

# Named Volume for node_modules is often root-owned on first create.
NODE_MODULES="$(pwd)/node_modules"
if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  sudo -n mkdir -p "$NODE_MODULES"
  sudo -n chown -R "$(id -u):$(id -g)" "$NODE_MODULES"
else
  mkdir -p "$NODE_MODULES"
  chown -R "$(id -u):$(id -g)" "$NODE_MODULES" || true
fi

echo "UV_PROJECT_ENVIRONMENT is set to ${UV_PROJECT_ENVIRONMENT}."