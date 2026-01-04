#!/bin/bash

# publish-article.sh
# Prepares the article for publication (final checks and metadata)

set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Check prerequisites
PREREQ_OUTPUT=$(scripts/bash/check-prerequisites.sh --json --require-spec)
FEATURE_DIR=$(echo "$PREREQ_OUTPUT" | grep -o '"FEATURE_DIR": "[^"]*"' | cut -d'"' -f4)
ARTICLE_FILE=$(echo "$PREREQ_OUTPUT" | grep -o '"ARTICLE_FILE": "[^"]*"' | cut -d'"' -f4)

if [ -z "$FEATURE_DIR" ]; then
    echo "$PREREQ_OUTPUT"
    exit 1
fi

if [ ! -f "$ARTICLE_FILE" ]; then
    echo "{\"error\": \"article.md not found. Run /blogkit.write first.\"}"
    exit 1
fi

# Extract title from article.md
TITLE=$(grep "^title:" "$ARTICLE_FILE" | sed 's/^title: *"\(.*\)"$/\1/' | head -1)
if [ -z "$TITLE" ]; then
    TITLE=$(grep "^# " "$ARTICLE_FILE" | head -1 | sed 's/^# //')
fi

# Generate slug if not present
SLUG=$(grep "^slug:" "$ARTICLE_FILE" | sed 's/^slug: *"\(.*\)"$/\1/' | head -1)
if [ -z "$SLUG" ]; then
    SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
fi

# Get current date if not present
PUBLISH_DATE=$(grep "^date:" "$ARTICLE_FILE" | sed 's/^date: *"\(.*\)"$/\1/' | head -1)
if [ -z "$PUBLISH_DATE" ]; then
    PUBLISH_DATE=$(date +%Y-%m-%d)
fi

# Generate excerpt if not present (first 150 characters of content)
EXCERPT=$(grep "^excerpt:" "$ARTICLE_FILE" | sed 's/^excerpt: *"\(.*\)"$/\1/' | head -1)
if [ -z "$EXCERPT" ] || [ "$EXCERPT" = '""' ]; then
    # Extract first paragraph from content (after frontmatter)
    CONTENT_START=$(awk '/^---$/ {if (++count == 2) exit} {if (count == 1) next} {print}' "$ARTICLE_FILE" | head -3)
    EXCERPT=$(echo "$CONTENT_START" | sed 's/^#.*$//' | sed 's/^<!--.*-->$//' | grep -v '^$' | head -1 | cut -c1-150)
    if [ -z "$EXCERPT" ]; then
        EXCERPT=""
    fi
fi

# Update frontmatter
# This is a simplified version - in production, use a proper YAML parser
TEMP_FILE=$(mktemp)
awk -v title="$TITLE" -v slug="$SLUG" -v date="$PUBLISH_DATE" -v excerpt="$EXCERPT" '
BEGIN { in_frontmatter = 0; frontmatter_done = 0 }
/^---$/ {
    if (in_frontmatter == 0) {
        in_frontmatter = 1
        print "---"
        next
    } else {
        in_frontmatter = 0
        frontmatter_done = 1
        print "title: \"" title "\""
        print "date: " date
        print "slug: \"" slug "\""
        print "tags: []"
        print "categories: []"
        print "excerpt: \"" excerpt "\""
        print "---"
        next
    }
}
in_frontmatter {
    if ($0 ~ /^title:/) { next }
    if ($0 ~ /^date:/) { next }
    if ($0 ~ /^slug:/) { next }
    if ($0 ~ /^excerpt:/) { next }
    print
    next
}
{ print }
' "$ARTICLE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$ARTICLE_FILE"

# Output JSON
cat <<EOF
{
  "FEATURE_DIR": "$FEATURE_DIR",
  "ARTICLE_FILE": "$ARTICLE_FILE",
  "TITLE": "$TITLE",
  "SLUG": "$SLUG",
  "PUBLISH_DATE": "$PUBLISH_DATE",
  "EXCERPT": "$EXCERPT",
  "STATUS": "ready_for_publication"
}
EOF

echo ""
echo "✅ Article prepared for publication!"
echo "Review the metadata in article.md and make final edits if needed."

