#!/usr/bin/env bash
# .claude 以下を ~/.claude にコピーする。
# persona.md / settings.json 等のローカル生成物は repo に無いため上書きされない。
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p ~/.claude
cp -R .claude/. ~/.claude/
