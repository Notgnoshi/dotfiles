#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

if [[ ! -f "$CLAUDE_PROJECT_DIR/Cargo.toml" ]]; then
    # Not a cargo project; skip
    exit 0
fi

# See: https://code.claude.com/docs/en/hooks#posttooluse-input for hook JSON input
if jq -e '.tool_input.file_path | endswith(".rs")' >/dev/null; then
    cargo fmt -- --config group_imports=StdExternalCrate,imports_granularity=Module
fi
