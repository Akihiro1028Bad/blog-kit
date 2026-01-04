#!/bin/bash

# blogkit-init.sh
# Initialize BlogKit in the current directory

set -e

REPO_ROOT="$(pwd)"
BLOGKIT_DIR="$REPO_ROOT/.blogkit"
POSTS_DIR="$REPO_ROOT/posts"
SCRIPTS_DIR="$REPO_ROOT/scripts"

echo "Initializing BlogKit..."

# Create .blogkit directory structure
mkdir -p "$BLOGKIT_DIR/memory"
mkdir -p "$BLOGKIT_DIR/templates"

# Create posts directory
mkdir -p "$POSTS_DIR"

# Create scripts directory structure
mkdir -p "$SCRIPTS_DIR/bash"
mkdir -p "$SCRIPTS_DIR/powershell"

# Create .cursor/commands directory
mkdir -p "$REPO_ROOT/.cursor/commands"

# Create .claude/commands directory
mkdir -p "$REPO_ROOT/.claude/commands"

# Create .github/prompts directory
mkdir -p "$REPO_ROOT/.github/prompts"

# Copy templates if they don't exist
if [ ! -f "$BLOGKIT_DIR/memory/constitution.md" ]; then
    echo "Creating constitution.md..."
    cat > "$BLOGKIT_DIR/memory/constitution.md" <<'EOF'
---
# Blog Writing Constitution
Version: 1.0.0
Ratification Date: 2025-01-XX
Last Amended: 2025-01-XX
---

## Writing Principles

### Clarity First
- MUST write in clear, concise language
- MUST avoid unnecessary jargon
- MUST explain technical terms when first introduced

### Structure Standards
- MUST use consistent heading hierarchy
- MUST include clear introduction and conclusion
- MUST organize content logically

## Content Guidelines

### Target Audience
- Define target audience clearly in spec.md
- Write at appropriate technical level
- Provide context for beginners when needed

### Length Guidelines
- Introduction: 300-500 words
- Main sections: 1000-2000 words each
- Conclusion: 300-500 words
- Total: Adjust based on topic complexity
EOF
fi

# Copy command templates if they don't exist
if [ ! -f "$REPO_ROOT/.cursor/commands/blogkit.specify.md" ]; then
    echo "BlogKit command templates will be created by the init process."
    echo "Note: Command templates should be manually copied or created."
fi

echo "✅ BlogKit initialized successfully!"
echo ""
echo "Next steps:"
echo "1. Use /blogkit.specify to create a new article specification"
echo "2. Use /blogkit.plan to create a writing plan"
echo "3. Use /blogkit.tasks to break down tasks"
echo "4. Use /blogkit.write to write the article"
echo "5. Use /blogkit.publish to prepare for publication"

