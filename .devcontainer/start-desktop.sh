#!/usr/bin/env bash
set -uo pipefail

echo "Starting VNC server..."

mkdir -p /tmp/vnc
exec 9>/tmp/vnc/start.lock
if ! flock -n 9; then
  echo "start-desktop already running; skipping"
  exit 0
fi

running() {
  pgrep -x "$1" >/dev/null 2>&1
}

if ! running Xvfb; then
  Xvfb :1 -screen 0 1280x800x24 -ac +extension GLX +render -noreset \
    >/tmp/vnc/xvfb.log 2>&1 &
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    [ -S /tmp/.X11-unix/X1 ] && break
    sleep 0.2
  done
fi

if ! running openbox; then
  DISPLAY=:1 openbox >/tmp/vnc/openbox.log 2>&1 &
fi

if ! running x11vnc; then
  x11vnc -display :1 -nopw -listen 127.0.0.1 -rfbport 5901 -forever -shared \
    >/tmp/vnc/x11vnc.log 2>&1 &
fi

if ! pgrep -f '/usr/bin/websockify' >/dev/null 2>&1; then
  websockify --web=/usr/share/novnc 6080 localhost:5901 \
    >/tmp/vnc/novnc.log 2>&1 &
fi

echo "VNC ready on 5901, noVNC on 6080"
exit 0
