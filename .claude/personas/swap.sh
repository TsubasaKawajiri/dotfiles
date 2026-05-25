#!/usr/bin/env bash
# ~/.claude/personas/swap.sh
# Switch the Claude Code "language" persona in ~/.claude/settings.json
#
# Usage:
#   bash ~/.claude/personas/swap.sh <persona>
#   bash ~/.claude/personas/swap.sh           # list available personas
#
# Personas are plain text files in ~/.claude/personas/ named <persona>.txt
# Add a new persona by dropping <name>.txt into this directory.

set -euo pipefail

PERSONA="${1:-}"
SETTINGS="$HOME/.claude/settings.json"
PERSONA_DIR="$HOME/.claude/personas"

if [[ -z "$PERSONA" ]]; then
  echo "Usage: bash $0 <persona>"
  echo
  echo "Available personas:"
  for f in "$PERSONA_DIR"/*.txt; do
    [[ -e "$f" ]] || continue
    name=$(basename "$f" .txt)
    echo "  - $name"
  done
  exit 0
fi

PERSONA_FILE="$PERSONA_DIR/${PERSONA}.txt"

if [[ ! -f "$PERSONA_FILE" ]]; then
  echo "Error: Unknown persona '$PERSONA'"
  echo "Available personas:"
  for f in "$PERSONA_DIR"/*.txt; do
    [[ -e "$f" ]] || continue
    name=$(basename "$f" .txt)
    echo "  - $name"
  done
  exit 1
fi

if [[ ! -f "$SETTINGS" ]]; then
  echo "Error: settings file not found at $SETTINGS"
  exit 1
fi

python3 - "$SETTINGS" "$PERSONA_FILE" <<'PYEOF'
import json
import sys

settings_path, persona_path = sys.argv[1], sys.argv[2]

with open(settings_path, "r", encoding="utf-8") as f:
    data = json.load(f)

with open(persona_path, "r", encoding="utf-8") as f:
    data["language"] = f.read().strip()

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")
PYEOF

echo "Switched persona to: $PERSONA"
echo "Effective on next Claude Code message."
