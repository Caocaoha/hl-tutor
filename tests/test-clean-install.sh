#!/usr/bin/env bash

set -euo pipefail

IMAGE="${HL_TUTOR_TEST_IMAGE:-ubuntu:24.04}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONTAINER_NAME="hl-tutor-clean-test-$$"

if [ -n "${HL_TUTOR_RAW_SETUP_URL:-}" ]; then
	SETUP_COMMAND="bash <(curl -fsSL ${HL_TUTOR_RAW_SETUP_URL})"
else
	SETUP_COMMAND="cd /workspace/hl-tutor && bash <(/bin/cat /workspace/hl-tutor/setup.sh)"
fi

cleanup() {
	docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}

trap cleanup EXIT

docker pull "$IMAGE" >/dev/null
docker run -d --name "$CONTAINER_NAME" -v "$REPO_ROOT:/workspace/hl-tutor:ro" "$IMAGE" sleep infinity >/dev/null

docker exec "$CONTAINER_NAME" bash -lc "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo curl ca-certificates util-linux" >/dev/null
docker exec "$CONTAINER_NAME" bash -lc "useradd -m -s /bin/bash tester && usermod -aG sudo tester && printf 'tester ALL=(ALL) NOPASSWD:ALL\n' >/etc/sudoers.d/tester && chmod 440 /etc/sudoers.d/tester"

docker exec -u tester "$CONTAINER_NAME" bash -lc "timeout 360s script -qec '/bin/bash -lc \"export TERM=xterm-256color; stty cols 220 rows 50; $SETUP_COMMAND\"' /tmp/hl-tutor-install.log; status=\$?; [ \"\$status\" -eq 124 ]"

docker exec -u tester "$CONTAINER_NAME" bash -lc "test -L ~/.local/bin/tutor"
docker exec -u tester "$CONTAINER_NAME" bash -lc "tmux has-session -t hl-tutor"
docker exec -u tester "$CONTAINER_NAME" bash -lc "test -f ~/tutor-workspace/.claude/settings.json"
docker exec -u tester "$CONTAINER_NAME" bash -lc "grep -Fq '\"defaultMode\": \"bypassPermissions\"' ~/.claude/settings.json"

docker exec -u tester "$CONTAINER_NAME" bash -lc "timeout 120s script -qec '/bin/bash -lc \"export TERM=xterm-256color; stty cols 220 rows 50; ~/.local/bin/tutor\"' /tmp/hl-tutor-runtime.log; status=\$?; [ \"\$status\" -eq 124 ]"
docker exec -u tester "$CONTAINER_NAME" bash -lc "tmux has-session -t hl-tutor"

printf 'clean install test passed in %s using %s\n' "$CONTAINER_NAME" "$IMAGE"
