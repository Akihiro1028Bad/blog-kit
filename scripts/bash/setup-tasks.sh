#!/bin/bash

# setup-tasks.sh
# Creates writing tasks (tasks.md) based on plan.md and spec.md

set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BLOGKIT_DIR="$REPO_ROOT/.blogkit"
TEMPLATES_DIR="$BLOGKIT_DIR/templates"

# Check prerequisites
PREREQ_OUTPUT=$(scripts/bash/check-prerequisites.sh --json --require-spec --require-plan)
FEATURE_DIR=$(echo "$PREREQ_OUTPUT" | grep -o '"FEATURE_DIR": "[^"]*"' | cut -d'"' -f4)
SPEC_FILE=$(echo "$PREREQ_OUTPUT" | grep -o '"SPEC_FILE": "[^"]*"' | cut -d'"' -f4)
PLAN_FILE=$(echo "$PREREQ_OUTPUT" | grep -o '"PLAN_FILE": "[^"]*"' | cut -d'"' -f4)
TASKS_FILE="$FEATURE_DIR/tasks.md"

if [ -z "$FEATURE_DIR" ]; then
    echo "$PREREQ_OUTPUT"
    exit 1
fi

# Read spec.md and plan.md
if [ ! -f "$SPEC_FILE" ] || [ ! -f "$PLAN_FILE" ]; then
    echo "{\"error\": \"Required files not found\"}"
    exit 1
fi

# Extract article title
ARTICLE_TITLE=$(grep "^# Article Specification:" "$SPEC_FILE" | sed 's/^# Article Specification: //' | head -1)
if [ -z "$ARTICLE_TITLE" ]; then
    ARTICLE_TITLE=$(grep "^# Writing Plan:" "$PLAN_FILE" | sed 's/^# Writing Plan: //' | head -1)
fi
if [ -z "$ARTICLE_TITLE" ]; then
    ARTICLE_TITLE="Untitled Article"
fi

# Create basic tasks.md
# This is a simplified version - AI can enhance it based on plan.md content
cat > "$TASKS_FILE" <<EOF
# Writing Tasks: $ARTICLE_TITLE

## Phase 1: Introduction
- **T001**: Write introduction section
- **T002**: Define article purpose and target audience

## Phase 2: Main Content
- **T003**: Write main content sections based on plan.md
- **T004**: Add code examples (if specified in plan.md)
- **T005**: Add visual elements (if specified in plan.md)

## Phase 3: Conclusion
- **T006**: Write conclusion section
- **T007**: Review and refine article

## Summary
- Total tasks: 7
- Estimated time: To be determined based on article length
EOF

# Output JSON
cat <<EOF
{
  "FEATURE_DIR": "$FEATURE_DIR",
  "TASKS_FILE": "$TASKS_FILE",
  "ARTICLE_TITLE": "$ARTICLE_TITLE"
}
EOF

