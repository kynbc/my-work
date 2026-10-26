#!/usr/bin/env bash
# Installs the CLI/runtime parts that can't live in the repo as plain files:
#   - agent-browser CLI (used by .claude/skills/agent-browser)
#   - GSD (get-shit-done) commands/agents/hooks into ./.claude (local install)
# Run once per environment from the repo root: bash scripts/setup-agent-tools.sh
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v agent-browser >/dev/null 2>&1; then
  npm install -g agent-browser
fi
# Reuse the pre-installed Chromium when present (cloud sessions); otherwise download one.
if [ -x /opt/pw-browsers/chromium ] || ls /opt/pw-browsers/chromium-*/chrome-linux/chrome >/dev/null 2>&1; then
  echo "Using pre-installed Chromium under /opt/pw-browsers"
else
  agent-browser install
fi

if [ ! -d .claude/get-shit-done ]; then
  npx -y get-shit-done-cc@latest --claude --local
fi
