#!/usr/bin/env bash
# Re-scan the studio root for every Claude Code skill location.
# Prints: authoring sources, consumer projects, and what's installed where.
#
# Usage: ./scripts/discover.sh [studio_root]
#   studio_root  Default: C:/code/ai
set -euo pipefail

ROOT="${1:-C:/code/ai}"

if [ ! -d "$ROOT" ]; then
    echo "Studio root not found: $ROOT" >&2
    exit 1
fi

echo "## Skill discovery — root: $ROOT"
echo ""

echo "### Authoring repos (top-level skills/ dirs)"
echo ""
find "$ROOT" -maxdepth 3 -type d -name "skills" 2>/dev/null \
    | grep -vE "node_modules|\.godot|companion_ai_core|otium_reborn|/\.claude/" \
    | sort \
    | while read -r d; do
        repo=$(dirname "$d")
        echo "- **$(basename "$repo")** — \`$d\`"
        ls "$d" 2>/dev/null | sed 's/^/  - /'
    done

echo ""
echo "### Consumer projects (.claude/skills/ dirs)"
echo ""
find "$ROOT" -maxdepth 6 -type d -path "*/.claude/skills" 2>/dev/null \
    | grep -vE "node_modules|\.godot" \
    | sort \
    | while read -r d; do
        proj=$(dirname "$(dirname "$d")")
        echo "- **$(basename "$proj")** — \`$d\`"
        ls "$d" 2>/dev/null | sed 's/^/  - /'
    done

echo ""
echo "### Git status of authoring repos"
echo ""
find "$ROOT" -maxdepth 3 -type d -name "skills" 2>/dev/null \
    | grep -vE "node_modules|\.godot|companion_ai_core|otium_reborn|/\.claude/" \
    | sort \
    | while read -r d; do
        repo=$(dirname "$d")
        name=$(basename "$repo")
        if [ -d "$repo/.git" ]; then
            commit=$(git -C "$repo" log -1 --format="%h %s" 2>/dev/null | head -c 80)
            remote=$(git -C "$repo" remote get-url origin 2>/dev/null || echo "_local-only_")
            echo "- **$name** — last: \`$commit\` · remote: \`$remote\`"
        else
            echo "- **$name** — _no git_"
        fi
    done
