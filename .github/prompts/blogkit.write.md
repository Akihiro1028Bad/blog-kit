---
description: "Write the article based on tasks.md, using AI assistance"
mode: blogkit.write
---

Write the article (article.md) based on the tasks defined in tasks.md.

The command:
1. Reads tasks.md to understand the writing tasks
2. Processes tasks in dependency order
3. Uses AI to generate content for each section
4. Combines sections into a complete article.md

**Usage**: `/blogkit.write`

**Script**: `scripts/bash/write-article.sh`

Execute: `scripts/bash/write-article.sh --json`

The script will:
1. Detect the current article directory (from git branch or SPECIFY_FEATURE env var)
2. Read tasks.md, plan.md, and spec.md from the article directory
3. Process each task in order
4. For each task, use AI to generate the content based on:
   - The task description
   - The article specification
   - The writing plan
   - Previous sections for context
5. Combine all sections into article.md
6. Add frontmatter with metadata (title, date, slug, etc.)

The AI should follow the writing principles from .blogkit/memory/constitution.md and the style guidelines from plan.md.

After execution, article.md will be created in the article directory. The user can review and edit it, then proceed to `/blogkit.publish` to prepare for publication.

