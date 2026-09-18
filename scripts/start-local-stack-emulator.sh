#!/usr/bin/env bash
# Boots the local dev stack: Firebase Auth emulator + the Cloud Run service,
# both backgrounded with output logged to scripts/.local/. Run from
# anywhere; paths are resolved relative to this script.
#
# The Cloud Run service is pointed at the emulator via
# FIREBASE_AUTH_EMULATOR_HOST, which firebase-admin picks up automatically
# — no code changes needed there. The Flutter client connects to the same
# emulator automatically in debug builds (see lib/main.dart), so
# `flutter run -d chrome` after this script is a fully offline loop that
# never touches the real Firebase project. Postgres is unaffected — this
# project uses Neon directly rather than a local instance, so there is
# nothing to start for that.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_DIR="$ROOT_DIR/scripts/.local"
mkdir -p "$LOCAL_DIR"

AUTH_EMULATOR_HOST="localhost:9099"

if [ -f "$LOCAL_DIR/emulator.pid" ] || [ -f "$LOCAL_DIR/cloud-run.pid" ]; then
  echo "Stack already appears to be running (found existing PID files)."
  echo "Run stop-local-stack.sh first if you want to restart it."
  exit 1
fi

if [ ! -d "$ROOT_DIR/cloud-run/node_modules" ]; then
  echo "==> Installing cloud-run dependencies (first run)..."
  (cd "$ROOT_DIR/cloud-run" && npm install)
fi

echo "==> Starting Firebase Auth emulator..."
(cd "$ROOT_DIR" && firebase emulators:start --only auth) \
  > "$LOCAL_DIR/emulator.log" 2>&1 &
echo $! > "$LOCAL_DIR/emulator.pid"

echo "==> Waiting for the Auth emulator on $AUTH_EMULATOR_HOST..."
for _ in $(seq 1 30); do
  if curl -s -o /dev/null "http://$AUTH_EMULATOR_HOST/"; then
    break
  fi
  sleep 1
done
if ! curl -s -o /dev/null "http://$AUTH_EMULATOR_HOST/"; then
  echo "Auth emulator did not come up — check scripts/.local/emulator.log"
  exit 1
fi

echo "==> Starting Cloud Run dev server..."
# npm start (not `npm run dev`) deliberately — `dev` runs under
# `node --watch`, which is a supervisor that respawns the server process
# even after its listening child is killed. That fights the explicit
# start/stop lifecycle these scripts are for: stop-local-stack.sh's
# port-based kill would be chasing a moving target and a "stopped" server
# could silently come back.
(
  cd "$ROOT_DIR/cloud-run"
  export FIREBASE_AUTH_EMULATOR_HOST="$AUTH_EMULATOR_HOST"
  npm start
) > "$LOCAL_DIR/cloud-run.log" 2>&1 &
echo $! > "$LOCAL_DIR/cloud-run.pid"

echo ""
echo "Local stack is up:"
echo "  Auth emulator UI  http://127.0.0.1:4000/auth"
echo "  Auth emulator API http://$AUTH_EMULATOR_HOST"
echo "  Cloud Run service http://localhost:8080"
echo ""
echo "Logs: scripts/.local/emulator.log, scripts/.local/cloud-run.log"
echo "Stop with: scripts/stop-local-stack.sh"
