#!/usr/bin/env bash
# ~/.claude/personas/swap.sh
# Switch the active persona written to ~/.claude/persona.md
# (persona.md is loaded from ~/.claude/CLAUDE.md via @persona.md)
#
# Usage:
#   bash ~/.claude/personas/swap.sh <persona>
#   bash ~/.claude/personas/swap.sh           # list available personas
#
# Personas are plain text files in ~/.claude/personas/ named <persona>.txt
# Add a new persona by dropping <name>.txt into this directory.

set -euo pipefail

PERSONA="${1:-}"
OUTPUT="$HOME/.claude/persona.md"
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

{
  echo "# ペルソナ（persona.md）"
  echo
  echo "以下の指示に従って、ユーザーへの回答の口調・話し方を決める。"
  echo "このファイルは \`personas/swap.sh\` が自動生成する。直接編集せず、\`personas/<name>.txt\` を編集して swap.sh を実行すること。"
  echo
  cat "$PERSONA_FILE"
  echo
} > "$OUTPUT"

echo "Switched persona to: $PERSONA"
echo "Effective on next Claude Code session (persona.md is loaded at startup)."
