#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

SANDBOX="sandbox.md"

write_template() {
    cat > "$1" <<'EOF'
---
layout: post
category: haiku
---

EOF
}

if [[ ! -e "$SANDBOX" ]]; then
    write_template "$SANDBOX"
    echo "created $SANDBOX — draft your haiku there, then run this again."
    exit 0
fi

# refuse to publish an empty draft (nothing but frontmatter / whitespace).
body=$(awk 'f { print } /^---$/ { c++; if (c == 2) f = 1 }' "$SANDBOX")
if ! grep -q '[^[:space:]]' <<<"$body"; then
    echo "sandbox body is empty — nothing to publish." >&2
    exit 1
fi

# next haiku number 
next=$(ls _posts/ \
    | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-haiku[0-9]*\.md$' \
    | sed -E 's/.*haiku([0-9]*)\.md/\1/' \
    | awk '{ if ($1 == "") print 1; else print $1 }' \
    | sort -n \
    | tail -1)
next=$((next + 1))

path="_posts/$(date +%Y-%m-%d)-haiku${next}.md"
if [[ -e "$path" ]]; then
    echo "refusing to overwrite $path" >&2
    exit 1
fi

cp "$SANDBOX" "$path"
write_template "$SANDBOX"
git add "$path"

echo "published -> $path"
echo "staged (not committed). sandbox reset."
