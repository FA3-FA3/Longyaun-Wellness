#!/usr/bin/env bash
# Stops the local dev stack started by start-local-stack.sh. Kills by
# tracked PID (whole process tree, since `firebase emulators:start` spawns
# children) and falls back to killing whatever is listening on the known
# ports, in case a previous run crashed without cleaning up its PID files.
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_DIR="$ROOT_DIR/scripts/.local"

kill_pid_tree() {
  local pid="$1"
  local label="$2"
  if [ -n "$pid" ] && tasklist //FI "PID eq $pid" 2>/dev/null | grep -q "$pid"; then
    echo "==> Stopping $label (PID $pid)..."
    taskkill //T //F //PID "$pid" > /dev/null 2>&1 || true
  fi
}

kill_by_port() {
  local port="$1"
  local label="$2"
  local pids
  pids=$(netstat -ano 2>/dev/null | grep "LISTENING" | grep ":$port " | awk '{print $NF}' | sort -u)
  for pid in $pids; do
    echo "==> Stopping stray $label on port $port (PID $pid)..."
    taskkill //T //F //PID "$pid" > /dev/null 2>&1 || true
  done
}

if [ -f "$LOCAL_DIR/emulator.pid" ]; then
  kill_pid_tree "$(cat "$LOCAL_DIR/emulator.pid")" "Auth emulator"
  rm -f "$LOCAL_DIR/emulator.pid"
fi

if [ -f "$LOCAL_DIR/cloud-run.pid" ]; then
  kill_pid_tree "$(cat "$LOCAL_DIR/cloud-run.pid")" "Cloud Run dev server"
  rm -f "$LOCAL_DIR/cloud-run.pid"
fi

# Fallback: catch anything left over from a crashed previous run.
kill_by_port 9099 "Auth emulator"
kill_by_port 4000 "Emulator UI"
kill_by_port 4400 "Emulator hub"
kill_by_port 4500 "Emulator logging"
kill_by_port 8080 "Cloud Run dev server"

echo "Local stack stopped."
