#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'HELP'
Usage: install.sh [--rebuild]

Install the agent-box launcher and Dockerfile into the current user's home.
Load a bundled local-agent-sandbox image archive when present. If there is no
archive, build the image only when it is missing.

Options:
  --rebuild  Build local-agent-sandbox:latest from the installed Dockerfile,
             even when an image with that tag already exists.
  -h, --help Show this help.
HELP
}

FORCE_BUILD=false
case "${1:-}" in
  "")
    ;;
  --rebuild)
    FORCE_BUILD=true
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_LAUNCHER="$SCRIPT_DIR/agent-box"
SOURCE_DOCKERFILE="$SCRIPT_DIR/Dockerfile"
IMAGE_ARCHIVE="$SCRIPT_DIR/local-agent-sandbox.tar.gz"
SANDBOX_DIR="$HOME/.agent-sandbox"
BIN_DIR="$HOME/.local/bin"
IMAGE_NAME="local-agent-sandbox:latest"

if ! grep -qiE 'microsoft.*(wsl2|standard-wsl2)' /proc/sys/kernel/osrelease; then
  echo "Error: This installer requires WSL 2." >&2
  exit 1
fi
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker CLI is not installed." >&2
  exit 1
fi
if ! docker version >/dev/null 2>&1; then
  echo "Error: Docker is not accessible from this shell." >&2
  echo "Open a WSL session with Docker access, then rerun this installer." >&2
  exit 1
fi
if [[ ! -f "$SOURCE_LAUNCHER" || ! -f "$SOURCE_DOCKERFILE" ]]; then
  echo "Error: installer needs agent-box and Dockerfile beside install.sh." >&2
  exit 1
fi

mkdir -p "$SANDBOX_DIR" "$BIN_DIR"
install -m 0644 "$SOURCE_DOCKERFILE" "$SANDBOX_DIR/Dockerfile"
install -m 0755 "$SOURCE_LAUNCHER" "$BIN_DIR/agent-box"

touch "$HOME/.bashrc"
if ! grep -Fq 'HOME/.local/bin' "$HOME/.bashrc"; then
  printf '%s\n' 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

if [[ "$FORCE_BUILD" == true ]]; then
  docker build -t "$IMAGE_NAME" "$SANDBOX_DIR"
elif [[ -f "$IMAGE_ARCHIVE" ]]; then
  docker load -i "$IMAGE_ARCHIVE"
elif ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  docker build -t "$IMAGE_NAME" "$SANDBOX_DIR"
else
  echo "Using existing image $IMAGE_NAME. Pass --rebuild to rebuild it."
fi

docker image inspect "$IMAGE_NAME" >/dev/null
echo "Installed $BIN_DIR/agent-box"
echo "Dockerfile: $SANDBOX_DIR/Dockerfile"
echo "Image: $IMAGE_NAME"
echo "Open a new shell or run: source $HOME/.bashrc"
