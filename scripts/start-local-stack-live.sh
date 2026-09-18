#!/usr/bin/env bash
# Boots the local dev stack in "live" mode: Cloud Run runs locally, but
# verifies real Firebase ID tokens against the actual longyuan-wellness
# project instead of the Auth emulator — no emulator process is started.
#
# Use this when you need to test against a real sign-in provider that
# doesn't behave well in the emulator (Google/Apple sign-in, etc.) or want
# production-like auth behavior. Postgres is the same real Neon database
# either way (no local instance) — the only thing that changes between
# this and start-local-stack-emulator.sh is where Auth verification
# happens. Real user tokens will hit this local server and real rows will
# land in Neon, same as any authenticated request against the deployed
# service would — this isn't a "safe/throwaway" mode the way emulator mode
# is.
#
# The Flutter client must also be told not to use the emulator for this to
# line up: `flutter run -d chrome --dart-define=USE_EMULATOR=false`.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_DIR="$ROOT_DIR/scripts/.local"
mkdir -p "$LOCAL_DIR"

if [ -f "$LOCAL_DIR/emulator.pid" ] || [ -f "$LOCAL_DIR/cloud-run.pid" ]; then
  echo "Stack already appears to be running (found existing PID files)."
  echo "Run stop-local-stack.sh first if you want to restart it."
  exit 1
fi

if [ ! -d "$ROOT_DIR/cloud-run/node_modules" ]; then
  echo "==> Installing cloud-run dependencies (first run)..."
  (cd "$ROOT_DIR/cloud-run" && npm install)
fi

echo "==> Starting Cloud Run dev server (live Firebase Auth, no emulator)..."
# npm start, not `npm run dev` — see start-local-stack-emulator.sh for why
# (`--watch`'s auto-respawn fights the explicit stop lifecycle).
(
  cd "$ROOT_DIR/cloud-run"
  unset FIREBASE_AUTH_EMULATOR_HOST
  npm start
) > "$LOCAL_DIR/cloud-run.log" 2>&1 &
echo $! > "$LOCAL_DIR/cloud-run.pid"

echo ""
echo "Local stack is up (live mode — real Firebase Auth, no emulator):"
echo "  Cloud Run service http://localhost:8080"
echo ""
echo "Run the client with: flutter run -d chrome --dart-define=USE_EMULATOR=false"
echo "Logs: scripts/.local/cloud-run.log"
echo "Stop with: scripts/stop-local-stack.sh"
