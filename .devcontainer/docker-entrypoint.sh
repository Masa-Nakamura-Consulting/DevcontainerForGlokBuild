#!/usr/bin/env bash
# Start the virtual desktop, then hand off to the image/CMD (sleep infinity).
/usr/local/bin/start-desktop.sh || true
exec "$@"
