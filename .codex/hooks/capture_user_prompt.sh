#!/bin/bash
set -e

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)

if [ -z "$REPO_ROOT" ]; then
exit 0
fi

cd "$REPO_ROOT"

mkdir -p .gitauto
LOG_FILE=".gitauto/hook.log"
HOOK_INPUT_FILE=$(mktemp "$REPO_ROOT/.gitauto/prompt-input.XXXXXX")
trap 'rm -f "$HOOK_INPUT_FILE"' EXIT
cat > "$HOOK_INPUT_FILE"

{
echo "=== git-auto prompt capture start ==="
date --iso-8601=seconds

if [ ! -s "$HOOK_INPUT_FILE" ]; then
echo "prompt capture skipped: empty stdin"
echo "=== git-auto prompt capture end ==="
exit 0
fi

PYTHON="$REPO_ROOT/.venv/bin/python"
if [ ! -x "$PYTHON" ]; then
PYTHON=$(command -v python3 || true)
fi

if [ -z "$PYTHON" ]; then
echo "git-auto: Python 실행 파일을 찾을 수 없음"
elif ! "$PYTHON" -c '
import json
import re
import sys
from pathlib import Path

source = Path(sys.argv[1])
data = json.loads(source.read_text(encoding="utf-8"))
session_id = data.get("session_id")
turn_id = data.get("turn_id")
prompt = data.get("prompt")

if not all(isinstance(value, str) and value for value in (session_id, turn_id, prompt)):
    raise ValueError("session_id, turn_id, prompt가 필요합니다.")
if not re.fullmatch(r"[A-Za-z0-9._-]+", session_id):
    raise ValueError("올바르지 않은 session_id입니다.")
if not re.fullmatch(r"[A-Za-z0-9._-]+", turn_id):
    raise ValueError("올바르지 않은 turn_id입니다.")

destination = Path(".gitauto") / "turns" / session_id / f"{turn_id}.json"
destination.parent.mkdir(parents=True, exist_ok=True)
destination.write_text(
    json.dumps(
        {"session_id": session_id, "turn_id": turn_id, "prompt": prompt},
        ensure_ascii=False,
        indent=2,
    )
    + "\n",
    encoding="utf-8",
)
' "$HOOK_INPUT_FILE"; then
echo "git-auto: 사용자 prompt 저장 실패"
fi

echo "=== git-auto prompt capture end ==="
} >> "$LOG_FILE" 2>&1
