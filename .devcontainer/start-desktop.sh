#!/usr/bin/env bash
set -euo pipefail

if ! pgrep -f "Xvfb :1" >/dev/null 2>&1; then
  Xvfb :1 -screen 0 1280x800x24 -ac +extension GLX +render -noreset >/tmp/vnc/xvfb.log 2>&1 &
  sleep 0.5
fi

if ! pgrep -f "openbox" >/dev/null 2>&1; then
  DISPLAY=:1 openbox >/tmp/vnc/openbox.log 2>&1 &
fi

if ! pgrep -f "x11vnc" >/dev/null 2>&1; then
  x11vnc -display :1 -nopw -listen 127.0.0.1 -rfbport 5901 -forever -shared \
    >/tmp/vnc/x11vnc.log 2>&1 &
fi

if ! pgrep -f "websockify" >/dev/null 2>&1; then
  websockify --web=/usr/share/novnc 6080 localhost:5901 >/tmp/vnc/novnc.log 2>&1 &
fi
