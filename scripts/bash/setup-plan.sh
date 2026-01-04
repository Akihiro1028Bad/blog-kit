#!/bin/bash

# setup-plan.sh
# Creates a writing plan (plan.md) based on spec.md and user instructions

set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BLOGKIT_DIR="$REPO_ROOT/.blogkit"
TEMPLATES_DIR="$BLOGKIT_DIR/templates"
CONSTITUTION_FILE="$BLOGKIT_DIR/memory/constitution.md"

# Get user instructions from arguments
WRITING_INSTRUCTIONS="$*"

# Check prerequisites
PREREQ_OUTPUT=$(scripts/bash/check-prerequisites.sh --json --require-spec)
FEATURE_DIR=$(echo "$PREREQ_OUTPUT" | grep -o '"FEATURE_DIR": "[^"]*"' | cut -d'"' -f4)
SPEC_FILE=$(echo "$PREREQ_OUTPUT" | grep -o '"SPEC_FILE": "[^"]*"' | cut -d'"' -f4)
PLAN_FILE="$FEATURE_DIR/plan.md"

if [ -z "$FEATURE_DIR" ]; then
    echo "$PREREQ_OUTPUT"
    exit 1
fi

# Read spec.md
if [ ! -f "$SPEC_FILE" ]; then
    echo "{\"error\": \"spec.md not found: $SPEC_FILE\"}"
    exit 1
fi

# Read constitution.md
CONSTITUTION_CONTENT=""
if [ -f "$CONSTITUTION_FILE" ]; then
    CONSTITUTION_CONTENT=$(cat "$CONSTITUTION_FILE")
fi

# Extract article title from spec.md
ARTICLE_TITLE=$(grep "^# Article Specification:" "$SPEC_FILE" | sed 's/^# Article Specification: //' | head -1)
if [ -z "$ARTICLE_TITLE" ]; then
    ARTICLE_TITLE="Untitled Article"
fi

# Create plan.md from template
if [ -f "$TEMPLATES_DIR/plan-template.md" ]; then
    PLAN_TEMPLATE=$(cat "$TEMPLATES_DIR/plan-template.md")
else
    # Create basic template if not found
    PLAN_TEMPLATE="# Writing Plan: {ARTICLE_TITLE}

## Writing Style
{WRITING_STYLE}

## Code Examples
{CODE_EXAMPLES}

## Visual Elements
{VISUAL_ELEMENTS}

## Section Breakdown
{SECTION_BREAKDOWN}

## Word Count Targets
{WORD_COUNT_TARGETS}

## Technical Details
{TECHNICAL_DETAILS}
"
fi

# Replace template placeholders
PLAN_CONTENT=$(echo "$PLAN_TEMPLATE" | \
    sed "s/{ARTICLE_TITLE}/$ARTICLE_TITLE/g" | \
    sed "s/{WRITING_STYLE}/$WRITING_INSTRUCTIONS/g" | \
    sed "s/{CODE_EXAMPLES}/To be defined/g" | \
    sed "s/{VISUAL_ELEMENTS}/To be defined/g" | \
    sed "s/{SECTION_BREAKDOWN}/To be defined/g" | \
    sed "s/{WORD_COUNT_TARGETS}/To be defined/g" | \
    sed "s/{TECHNICAL_DETAILS}/To be defined/g")

# Write plan.md
echo "$PLAN_CONTENT" > "$PLAN_FILE"

# Output JSON
cat <<EOF
{
  "FEATURE_DIR": "$FEATURE_DIR",
  "PLAN_FILE": "$PLAN_FILE",
  "SPEC_FILE": "$SPEC_FILE",
  "ARTICLE_TITLE": "$ARTICLE_TITLE"
}
EOF

