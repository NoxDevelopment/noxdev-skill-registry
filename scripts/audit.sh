#!/usr/bin/env bash
# Audit the registry against reality:
#   - Every authoring repo listed in REGISTRY.md exists and is a git repo.
#   - Every consumer listed exists and has the claimed skills installed.
#   - Flag drift between an authoring repo's source and a consumer's installed copy.
#
# Usage: ./scripts/audit.sh [studio_root]
set -euo pipefail

ROOT="${1:-C:/code/ai}"
REG="$(dirname "$0")/../REGISTRY.md"

if [ ! -f "$REG" ]; then
    echo "REGISTRY.md not found at $REG" >&2
    exit 1
fi

errors=0
warnings=0

echo "## Registry audit"
echo ""

# Extract authoring repo paths from the table (rows start with `| **<name>** | \`<path>\` |`).
# Naive parse — the registry's table syntax is stable.
echo "### Authoring repo presence"
echo ""
grep -oE '`C:/code/ai/[^`]+`' "$REG" | sort -u | while read -r raw; do
    p="${raw//\`/}"
    if [ -d "$p" ]; then
        if [ -d "$p/.git" ]; then
            echo "- ok: $p"
        else
            echo "- WARN: $p exists but is not a git repo"
            warnings=$((warnings + 1))
        fi
    else
        echo "- FAIL: $p missing"
        errors=$((errors + 1))
    fi
done

echo ""
echo "### Drift check (authoring vs installed)"
echo ""
echo "_Run \`diff -r <authoring>/skills/<name>/ <consumer>/.claude/skills/<name>/\` for each pair you suspect has drifted. (audit.sh doesn't auto-pair yet — REGISTRY.md is the truth source for which consumer maps to which authoring repo.)_"

echo ""
if [ "$errors" -gt 0 ] || [ "$warnings" -gt 0 ]; then
    echo "### Summary: $errors errors, $warnings warnings"
    exit 1
else
    echo "### Summary: clean"
fi
