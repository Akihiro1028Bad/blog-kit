---
description: "Create a new blog article specification from a natural language description"
mode: blogkit.specify
---

Create a new blog article specification based on the user's description.

The command executes the create-new-post script to:
1. Generate the next article number (001, 002, etc.)
2. Create a semantic directory name from the description
3. Create the article directory structure (posts/XXX-article-name/)
4. Generate spec.md from template with the description

**Usage**: `/blogkit.specify [article description]`

**Example**: `/blogkit.specify TypeScriptの型安全性について解説する記事を書きたい。初心者向けに、基本的な型の使い方から、高度な型操作まで段階的に説明する。`

**Script**: `scripts/bash/create-new-post.sh`

**Arguments**: `$ARGUMENTS`

Execute: `scripts/bash/create-new-post.sh --json $ARGUMENTS`

The script will output JSON with:
- `ARTICLE_NUM`: Article number (e.g., "001")
- `DIR_NAME`: Directory name (e.g., "001-typescript-type-safety")
- `POST_DIR`: Full path to article directory
- `SPEC_FILE`: Path to generated spec.md

After execution, the spec.md file will be created in the article directory. The user can then edit it to refine the article specification, or proceed to `/blogkit.plan` to create a writing plan.

