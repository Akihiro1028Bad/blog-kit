---
description: "Break down the writing plan into actionable tasks"
mode: blogkit.tasks
---

Break down the writing plan (plan.md) into actionable writing tasks organized by phase.

The command:
1. Reads the current article's plan.md and spec.md
2. Analyzes the section breakdown and requirements
3. Generates tasks.md with:
   - Phase-based organization
   - Task descriptions
   - Dependencies between tasks
   - Estimated effort

**Usage**: `/blogkit.tasks`

**Script**: `scripts/bash/setup-tasks.sh`

Execute: `scripts/bash/setup-tasks.sh --json`

The script will:
1. Detect the current article directory (from git branch or SPECIFY_FEATURE env var)
2. Read plan.md and spec.md from the article directory
3. Generate tasks.md with tasks organized by phase
4. Include task IDs (T001, T002, etc.)
5. Mark dependencies and parallel execution opportunities

After execution, tasks.md will be created in the article directory. The user can then proceed to `/blogkit.write` to execute the tasks and write the article.

