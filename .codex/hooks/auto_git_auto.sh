#!/bin/bash
set -e

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)

if [ -z "$REPO_ROOT" ]; then
exit 0
fi

cd "$REPO_ROOT"

mkdir -p .gitauto
LOG_FILE=".gitauto/hook.log"
HOOK_INPUT_FILE=$(mktemp "$REPO_ROOT/.gitauto/hook-input.XXXXXX")
trap 'rm -f "$HOOK_INPUT_FILE"' EXIT
cat > "$HOOK_INPUT_FILE"

{
echo "=== git-auto hook start ==="
date --iso-8601=seconds
echo "repo: $REPO_ROOT"

GIT_AUTO="$REPO_ROOT/.venv/bin/git-auto"

if [ ! -x "$GIT_AUTO" ]; then
GIT_AUTO=$(command -v git-auto || true)
fi

if [ -z "$GIT_AUTO" ]; then
echo "git-auto: 실행 파일을 찾을 수 없음"
exit 1
fi

if git diff --quiet && git diff --cached --quiet; then
echo "git-auto: 변경사항 없음, pending auto-finish 확인"
"$GIT_AUTO" auto-finish run
echo "=== git-auto hook end ==="
exit 0
fi

PYTHON="$REPO_ROOT/.venv/bin/python"
if [ ! -x "$PYTHON" ]; then
PYTHON=$(command -v python3 || true)
fi

STOP_SESSION_PRESENT=false
STOP_TURN_PRESENT=false
EXACT_PROMPT_PATH=""
EXACT_PROMPT_FOUND=false
FALLBACK_PROMPT_PATH=""
FALLBACK_PROMPT_USED=false
PROMPT_INPUT_FILE=""
if [ -n "$PYTHON" ]; then
mapfile -t PROMPT_LOOKUP < <("$PYTHON" -c '
import json
import re
import sys
from pathlib import Path

try:
    data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    data = {}
session_id = data.get("session_id")
turn_id = data.get("turn_id")
safe_session = (
    session_id
    if isinstance(session_id, str) and re.fullmatch(r"[A-Za-z0-9._-]+", session_id)
    else None
)
safe_turn = (
    turn_id
    if isinstance(turn_id, str) and re.fullmatch(r"[A-Za-z0-9._-]+", turn_id)
    else None
)
session_dir = Path(".gitauto") / "turns" / safe_session if safe_session else None
exact_path = session_dir / f"{safe_turn}.json" if session_dir and safe_turn else None
exact_found = bool(exact_path and exact_path.is_file())
fallback_path = None
fallback_used = False
final_path = exact_path if exact_found else None

if final_path is None and session_dir and session_dir.is_dir():
    candidates = [path for path in session_dir.glob("*.json") if path.is_file()]
    if candidates:
        fallback_path = max(candidates, key=lambda path: path.stat().st_mtime_ns)
        fallback_used = True
        final_path = fallback_path

values = (
    bool(safe_session),
    bool(safe_turn),
    str(exact_path) if exact_path else "",
    exact_found,
    str(fallback_path) if fallback_path else "",
    fallback_used,
    str(final_path) if final_path else "",
)
for value in values:
    print(str(value).lower() if isinstance(value, bool) else value)
' "$HOOK_INPUT_FILE" 2>/dev/null || true)
if [ "${#PROMPT_LOOKUP[@]}" -eq 7 ]; then
STOP_SESSION_PRESENT=${PROMPT_LOOKUP[0]}
STOP_TURN_PRESENT=${PROMPT_LOOKUP[1]}
EXACT_PROMPT_PATH=${PROMPT_LOOKUP[2]}
EXACT_PROMPT_FOUND=${PROMPT_LOOKUP[3]}
FALLBACK_PROMPT_PATH=${PROMPT_LOOKUP[4]}
FALLBACK_PROMPT_USED=${PROMPT_LOOKUP[5]}
PROMPT_INPUT_FILE=${PROMPT_LOOKUP[6]}
fi
fi

echo "stop session_id present: $STOP_SESSION_PRESENT"
echo "stop turn_id present: $STOP_TURN_PRESENT"
echo "exact prompt path: $EXACT_PROMPT_PATH"
echo "exact prompt found: $EXACT_PROMPT_FOUND"
echo "fallback prompt path: $FALLBACK_PROMPT_PATH"
echo "fallback prompt used: $FALLBACK_PROMPT_USED"
echo "git-auto executable: $GIT_AUTO"
echo "git-auto: 변경사항 감지, git-auto commit --yes --no-ai --agent codex 실행"

COMMIT_ARGS=(commit --yes --no-ai --agent codex --hook-input "$HOOK_INPUT_FILE")
if [ -n "$PROMPT_INPUT_FILE" ] && [ -f "$PROMPT_INPUT_FILE" ]; then
COMMIT_ARGS+=(--prompt-input "$PROMPT_INPUT_FILE")
echo "final prompt-input passed: true"
else
echo "final prompt-input passed: false"
fi

"$GIT_AUTO" "${COMMIT_ARGS[@]}"

echo "=== git-auto hook end ==="
} >> "$LOG_FILE" 2>&1
