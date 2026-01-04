---
description: "Create a writing plan for the current article based on spec.md"
mode: blogkit.plan
---

Create a writing plan (plan.md) for the current article based on the specification in spec.md.

The command:
1. Reads the current article's spec.md
2. Analyzes the article theme and requirements
3. Generates a writing plan based on user's instructions about:
   - Writing style preferences
   - Code example requirements
   - Visual elements (diagrams, screenshots)
   - Section breakdown
   - Word count targets

**Usage**: `/blogkit.plan [writing instructions]`

**Example**: `/blogkit.plan コード例はTypeScriptで記述。実践的なサンプルを3-4個含める。図表は不要。初心者にもわかりやすい説明を心がける。`

**Script**: `scripts/bash/setup-plan.sh`

**Arguments**: `$ARGUMENTS`

The script will:
1. Detect the current article directory (from git branch or SPECIFY_FEATURE env var)
2. Read spec.md from the article directory
3. Read .blogkit/memory/constitution.md for writing principles
4. Generate plan.md based on the template and user instructions
5. Update plan.md with writing style, code examples, visual elements, and section breakdown

Execute: `scripts/bash/setup-plan.sh $ARGUMENTS`

After execution, plan.md will be created in the article directory. The user can then proceed to `/blogkit.tasks` to break down the plan into actionable writing tasks.

