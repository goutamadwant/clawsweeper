#!/usr/bin/env bash
set -euo pipefail

node_major="$(node -p 'process.versions.node.split(".")[0]')"
if [[ "$node_major" -lt 24 ]]; then
  echo "Node 24 or newer is required" >&2
  exit 1
fi

pnpm run build:node
unset CLAWSWEEPER_ACTION_LEDGER_INVOCATION
CLAWSWEEPER_EXACT_LABEL_PROOF=1 node --test \
  --test-name-pattern='command-only comment activity|exact publication syncs fresh-head PR labels|skips fresh-head PR label sync when humans act|exact publication withholds fresh-head PR label sync from close proposals' \
  test/apply-label-sync.test.ts
