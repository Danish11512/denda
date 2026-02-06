#!/usr/bin/env bash
# Backend dev environment: create venv, install deps, load env, then spawn a shell.
# On exit (normal, failure, or SIGINT), the venv and any temp artifacts are removed.
# Run from repo root or backend/: ./backend/scripts/ensure-venv.sh  (or scripts/ensure-venv.sh from backend/)

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VENV_DIR="$BACKEND_DIR/.venv"

cleanup() {
  rm -rf "$VENV_DIR"
}
trap cleanup EXIT INT TERM

echo "Creating venv at $VENV_DIR ..."
python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install -r "$BACKEND_DIR/requirements.txt" --quiet

cd "$BACKEND_DIR"
source "$VENV_DIR/bin/activate"
if [ -f "$BACKEND_DIR/.env" ]; then
  set -a
  source "$BACKEND_DIR/.env"
  set +a
  echo "Loaded .env"
fi
echo "Backend ready. Exit this shell to remove the venv."
$SHELL
