#!/bin/bash

# check-prerequisites.sh
# Checks prerequisites for BlogKit commands

set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BLOGKIT_DIR="$REPO_ROOT/.blogkit"
POSTS_DIR="$REPO_ROOT/posts"

# Detect current article directory
# Priority: 1. SPECIFY_FEATURE env var, 2. Git branch name, 3. Error
if [ -n "$SPECIFY_FEATURE" ]; then
    FEATURE_DIR="$POSTS_DIR/$SPECIFY_FEATURE"
elif command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "")
    if [ -n "$BRANCH" ] && [[ "$BRANCH" =~ ^[0-9]+- ]]; then
        FEATURE_DIR="$POSTS_DIR/$BRANCH"
    fi
fi

# Output JSON if requested
if [ "$1" = "--json" ]; then
    OUTPUT_JSON=true
    shift
else
    OUTPUT_JSON=false
fi

# Check for required files
REQUIRE_SPEC=false
REQUIRE_PLAN=false
REQUIRE_TASKS=false

while [ $# -gt 0 ]; do
    case "$1" in
        --require-spec)
            REQUIRE_SPEC=true
            shift
            ;;
        --require-plan)
            REQUIRE_PLAN=true
            shift
            ;;
        --require-tasks)
            REQUIRE_TASKS=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Validate feature directory
if [ -z "$FEATURE_DIR" ]; then
    if [ "$OUTPUT_JSON" = true ]; then
        echo '{"error": "No active article found. Set SPECIFY_FEATURE env var or use a numbered branch (e.g., 001-article-name)"}'
    else
        echo "Error: No active article found."
        echo "Set SPECIFY_FEATURE env var or use a numbered branch (e.g., 001-article-name)"
    fi
    exit 1
fi

if [ ! -d "$FEATURE_DIR" ]; then
    if [ "$OUTPUT_JSON" = true ]; then
        echo "{\"error\": \"Article directory not found: $FEATURE_DIR\"}"
    else
        echo "Error: Article directory not found: $FEATURE_DIR"
    fi
    exit 1
fi

# Check for required files
ERRORS=()

if [ "$REQUIRE_SPEC" = true ] && [ ! -f "$FEATURE_DIR/spec.md" ]; then
    ERRORS+=("spec.md not found")
fi

if [ "$REQUIRE_PLAN" = true ] && [ ! -f "$FEATURE_DIR/plan.md" ]; then
    ERRORS+=("plan.md not found")
fi

if [ "$REQUIRE_TASKS" = true ] && [ ! -f "$FEATURE_DIR/tasks.md" ]; then
    ERRORS+=("tasks.md not found")
fi

if [ ${#ERRORS[@]} -gt 0 ]; then
    if [ "$OUTPUT_JSON" = true ]; then
        echo "{\"error\": \"Missing required files: ${ERRORS[*]}\"}"
    else
        echo "Error: Missing required files:"
        printf '  - %s\n' "${ERRORS[@]}"
    fi
    exit 1
fi

# Output JSON
if [ "$OUTPUT_JSON" = true ]; then
    cat <<EOF
{
  "FEATURE_DIR": "$FEATURE_DIR",
  "SPEC_FILE": "$FEATURE_DIR/spec.md",
  "PLAN_FILE": "$FEATURE_DIR/plan.md",
  "TASKS_FILE": "$FEATURE_DIR/tasks.md",
  "ARTICLE_FILE": "$FEATURE_DIR/article.md",
  "HAS_SPEC": $([ -f "$FEATURE_DIR/spec.md" ] && echo "true" || echo "false"),
  "HAS_PLAN": $([ -f "$FEATURE_DIR/plan.md" ] && echo "true" || echo "false"),
  "HAS_TASKS": $([ -f "$FEATURE_DIR/tasks.md" ] && echo "true" || echo "false"),
  "HAS_ARTICLE": $([ -f "$FEATURE_DIR/article.md" ] && echo "true" || echo "false")
}
EOF
else
    echo "Feature directory: $FEATURE_DIR"
    [ -f "$FEATURE_DIR/spec.md" ] && echo "✓ spec.md exists" || echo "✗ spec.md missing"
    [ -f "$FEATURE_DIR/plan.md" ] && echo "✓ plan.md exists" || echo "✗ plan.md missing"
    [ -f "$FEATURE_DIR/tasks.md" ] && echo "✓ tasks.md exists" || echo "✗ tasks.md missing"
    [ -f "$FEATURE_DIR/article.md" ] && echo "✓ article.md exists" || echo "✗ article.md missing"
fi

