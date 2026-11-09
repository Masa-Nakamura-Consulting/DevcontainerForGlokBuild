# .devcontainer settings for using Grok Build comfortably and safely from VS Code.

# Grok Build isolated devcontainer (GH_TOKEN only)

## TL;DR

- The container is locked down for security: 1) root is unavailable 2) GitHub cannot be reached with SSH keys 3) Python uv does not use its default directory 4) Node does not use its default directory.
  - When you create more than one Python uv project, switch `UV_PROJECT_ENVIRONMENT`.
  - When you create more than one Node project, add a workspace to the root `package.json`.
- Playwright e2e tests are set up. For noVNC and headed mode, read the sample README files: `samples/python/htmx-todo/README.md` and `samples/react/README.md`.

Do not mount SSH keys. Authentication uses only a fine-grained `GH_TOKEN`.
Do not pass the Docker socket or `~/.aws`.

## Included from the start

- Node.js 22 (devcontainer feature)
- uv (`~/.local/bin`)
- Grok CLI
- git / gh
- Xvfb + x11vnc + noVNC

## uv virtual environment

`UV_PROJECT_ENVIRONMENT` is `/var/uv-venvs/`. This absolute path is itself one virtual environment, and every uv project in the container shares it. `uv sync` removes packages in this environment that are not dependencies of the current project.

When you keep another Python project alongside it, set a different absolute path for that work only.

```bash
UV_PROJECT_ENVIRONMENT=/var/uv-venvs/another-app uv sync
```

## Node apps

Add each Node app to the npm workspace at the repository root. Dependencies are installed into the root `node_modules` directory (a named volume). The workspace is mounted with sshfs, so `node_modules/.bin` created inside an app directory cannot be executed.

1. Place a `package.json` in the app directory.
2. Add that directory to `workspaces` in the root `package.json`. When there is more than one app, list each path.

```json
"workspaces": [
  "samples/react",
  "samples/another-node-app"
]
```

3. Install from the repository root.

```bash
npm install
```

4. Run scripts from the app directory.

```bash
cd samples/another-node-app
npm run dev
```

The existing example is `samples/react`.

## Passing GH_TOKEN

Set it on the remote host (the SSH Remote connection target).

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

After that, run Remote-SSH: Kill VS Code Server on Host, then reconnect.
`devcontainer.json` passes it into the container with `"GH_TOKEN": "${localEnv:GH_TOKEN}"`.

The token permission is Contents, Read and write, only. Limit it to the target repository. Do not grant Admin, Secrets, or Actions.

## GitHub (keep the existing process)

Branch protection blocks direct pushes to master and to branches that correspond to production. Changes go through a pull request and approval and merge on the web.

## Startup

Place this `.devcontainer` at the repository root and use Reopen in Container in VS Code.

- Extension: `PawelHuryn.grok-vscode-phuryn` (Marketplace name: GUI for Grok Build & Muse Code)
- Display: `DISPLAY=:1` inside the container. noVNC is port 6080. VNC is 5901 (no password; intended for local forwarding)
- The desktop starts from the image `ENTRYPOINT` (`overrideCommand: false`). `postStartCommand` and `postAttachCommand` run `/usr/local/bin/start-desktop.sh` again and do nothing when it is already running. **After changing these settings, Rebuild Container is required.**
- Log in to Grok with `grok login` inside the container, or pass `XAI_API_KEY` only at runtime

## What not to pass in

- `~/.ssh` (including a dedicated key directory)
- `~/.aws`, browser profiles, and the Docker socket
- API keys baked into the image
