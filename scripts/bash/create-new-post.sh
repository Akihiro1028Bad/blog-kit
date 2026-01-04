#!/bin/bash

# create-new-post.sh
# Creates a new blog post directory structure with spec.md

set -e

# Get arguments
FEATURE_DESC="$*"

if [ -z "$FEATURE_DESC" ]; then
    echo "Error: Article description is required"
    echo "Usage: create-new-post.sh \"Article description\""
    exit 1
fi

# Get repository root (assumes script is in scripts/bash/)
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BLOGKIT_DIR="$REPO_ROOT/.blogkit"
POSTS_DIR="$REPO_ROOT/posts"
TEMPLATES_DIR="$BLOGKIT_DIR/templates"

# Find next article number
NEXT_NUM=1
if [ -d "$POSTS_DIR" ]; then
    for dir in "$POSTS_DIR"/*; do
        if [ -d "$dir" ]; then
            BASENAME=$(basename "$dir")
            NUM=$(echo "$BASENAME" | grep -oE '^[0-9]+' || echo "0")
            if [ "$NUM" -ge "$NEXT_NUM" ]; then
                NEXT_NUM=$((NUM + 1))
            fi
        fi
    done
fi

# Format article number (001, 002, etc.)
ARTICLE_NUM=$(printf "%03d" "$NEXT_NUM")

# Generate short name from description
# Remove common words, take first 3-4 meaningful words
SHORT_NAME=$(echo "$FEATURE_DESC" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9 ]//g' | \
    awk '{
        for(i=1;i<=NF;i++) {
            if(length($i) >= 3 && $i !~ /^(the|and|for|are|but|not|you|all|can|her|was|one|our|out|day|get|has|him|his|how|man|new|now|old|see|two|way|who|boy|did|its|let|put|say|she|too|use)$/) {
                print $i
            }
        }
    }' | head -4 | tr '\n' '-' | sed 's/-$//')

# Ensure short name is not empty
if [ -z "$SHORT_NAME" ]; then
    SHORT_NAME="article"
fi

# Limit length (GitHub branch name limit: 244 bytes, but we'll be more conservative)
SHORT_NAME=$(echo "$SHORT_NAME" | cut -c1-50)

# Create directory name
DIR_NAME="${ARTICLE_NUM}-${SHORT_NAME}"
POST_DIR="$POSTS_DIR/$DIR_NAME"

# Create directory structure
mkdir -p "$POST_DIR/assets"

# Get current date
CREATED_DATE=$(date +%Y-%m-%d)

# Create spec.md from template
if [ -f "$TEMPLATES_DIR/spec-template.md" ]; then
    sed -e "s/{ARTICLE_TITLE}/$(echo "$FEATURE_DESC" | head -c 100)/g" \
        -e "s/{ARTICLE_NUMBER}/$ARTICLE_NUM/g" \
        -e "s/{CREATED_DATE}/$CREATED_DATE/g" \
        -e "s/{ARTICLE_THEME}/$FEATURE_DESC/g" \
        -e "s/{TARGET_AUDIENCE}/To be defined/g" \
        -e "s/{CONTENT_STRUCTURE}/To be defined/g" \
        -e "s/{KEY_POINTS}/To be defined/g" \
        -e "s/{SUCCESS_CRITERIA}/To be defined/g" \
        -e "s/{NOTES}//g" \
        "$TEMPLATES_DIR/spec-template.md" > "$POST_DIR/spec.md"
else
    # Create basic spec.md if template doesn't exist
    cat > "$POST_DIR/spec.md" <<EOF
# Article Specification: $(echo "$FEATURE_DESC" | head -c 100)

**Article Number**: $ARTICLE_NUM
**Created**: $CREATED_DATE
**Status**: Draft

## Article Theme
$FEATURE_DESC

## Target Audience
To be defined

## Content Structure
To be defined

## Key Points
To be defined

## Success Criteria
To be defined
EOF
fi

# Output JSON for command integration
cat <<EOF
{
  "ARTICLE_NUM": "$ARTICLE_NUM",
  "DIR_NAME": "$DIR_NAME",
  "POST_DIR": "$POST_DIR",
  "SPEC_FILE": "$POST_DIR/spec.md"
}
EOF

