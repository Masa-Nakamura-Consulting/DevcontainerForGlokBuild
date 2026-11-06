# .devcontainer settings for using Grok Build comfortably and safely from VS Code.

# Grok Build isolated devcontainer (GH_TOKEN only)

SSH 鍵はマウントしない。認証は fine-grained token の `GH_TOKEN` のみ。
Docker socket と `~/.aws` は渡さない。

## 最初から入るもの

- Node.js 22（devcontainer feature）
- uv（`~/.local/bin`）
- Grok CLI
- git / gh
- Xvfb + x11vnc + noVNC

## GH_TOKEN の渡し方

リモートホスト（SSH Remote の接続先）で設定する。

```bash
mkdir -p ~/.config
umask 077
echo 'export GH_TOKEN="github_pat_..."' > ~/.config/devcontainer-secrets
chmod 600 ~/.config/devcontainer-secrets

grep -q devcontainer-secrets ~/.bashrc || \
  echo '[ -f ~/.config/devcontainer-secrets ] && . ~/.config/devcontainer-secrets' >> ~/.bashrc
grep -q devcontainer-secrets ~/.profile || \
  echo '[ -f ~/.config/devcontainer-secrets ] && . ~/.config/devcontainer-secrets' >> ~/.profile
```

設定後、Remote-SSH: Kill VS Code Server on Host を実行してから再接続する。
`devcontainer.json` は `"GH_TOKEN": "${localEnv:GH_TOKEN}"` でコンテナに渡す。

トークンの権限は Contents の Read and write のみ。対象リポジトリだけ。Admin / Secrets / Actions は付けない。

## GitHub（既存運用のまま）

master と本番相当ブランチは branch protection で直接 push を禁止し、PR と Web 上の承認・マージだけにする。

## 起動

リポジトリ直下にこの `.devcontainer` を置き、VS Code で Reopen in Container。

- 拡張: `PawelHuryn.grok-vscode-phuryn`（Marketplace 名は GUI for Grok Build & Muse Code）
- 画面: コンテナ内 `DISPLAY=:1`。noVNC はポート 6080。VNC は 5901（パスワードなし、ローカル転送想定）
- デスクトップはイメージの `ENTRYPOINT` で起動する（`overrideCommand: false`）。`postStartCommand` / `postAttachCommand` は `/usr/local/bin/start-desktop.sh` を再実行し、既に起動済みなら何もしない。**設定変更後は Rebuild Container が必要。**
- Grok のログインはコンテナ内で `grok login`、または `XAI_API_KEY` を実行時だけ渡す

## 渡さないもの

- `~/.ssh`（専用鍵ディレクトリも含む）
- `~/.aws`、ブラウザプロファイル、Docker socket
- イメージへの API キー焼き込み
