#!/usr/bin/env bash
set -euo pipefail

# Fine-grained token のみ。SSH 鍵は使わない。
if [[ -n "${GH_TOKEN:-}" ]]; then
  printf '%s\n' "$GH_TOKEN" | gh auth login --with-token
  gh auth setup-git
  echo "gh authenticated via GH_TOKEN"
else
  echo "WARN: GH_TOKEN が未設定です。リモートホストで環境変数をセットしてコンテナを作り直してください。" >&2
fi

git config --global user.name "${GIT_AUTHOR_NAME:-grok-devcontainer}"
git config --global user.email "${GIT_AUTHOR_EMAIL:-grok-devcontainer@local}"
git config --global --add safe.directory "*"

echo "master 直 push 禁止は GitHub branch protection 側で維持すること。"
