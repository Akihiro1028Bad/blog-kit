---
description: "Clarify and refine article specification by resolving ambiguities"
---

Clarify the article specification (spec.md) by identifying and resolving ambiguities, undefined areas, and missing details.

The command:
1. Reads the current article's spec.md
2. Analyzes for:
   - `[NEEDS CLARIFICATION: ...]` markers (max 3 allowed)
   - "To be defined" placeholders
   - Ambiguous requirements
   - Missing edge cases
   - Undefined constraints
3. Generates structured questions with suggested answers
4. Updates spec.md with user responses

**Usage**: `/blogkit.clarify [optional focus areas]`

**Example**: `/blogkit.clarify`
**Example**: `/blogkit.clarify Focus on target audience and content structure`

**Script**: `scripts/bash/clarify-spec.sh`

**Arguments**: `$ARGUMENTS` (optional focus areas)

Execute: `scripts/bash/clarify-spec.sh --json $ARGUMENTS`

The script will:
1. Detect the current article directory (from git branch or SPECIFY_FEATURE env var)
2. Read spec.md from the article directory
3. Analyze for ambiguities and undefined areas
4. Output JSON with analysis results

**AI Processing**:
After the script runs, the AI should:
1. Read the full spec.md content
2. Identify all ambiguities and undefined areas
3. Generate structured questions with suggested answers
4. Present questions to the user in this format:

---
## Question 1: [Topic]

**Context**: [Where this appears in spec.md, including line number or section]
**What we need to know**: [What information is needed]

**Suggested Answers**:
| Option | Answer | Implications |
|--------|--------|--------------|
| A | [Option A description] | [What this choice means for the article] |
| B | [Option B description] | [What this choice means for the article] |
| C | [Option C description] | [What this choice means for the article] |
| Custom | Your own approach | [Describe your preference] |

**Your choice**: _[Wait for user response]_
---

5. Collect user responses (format: "Q1: A", "Q2: B", "Q3: Custom - [description]")
6. Update spec.md by:
   - Replacing `[NEEDS CLARIFICATION: ...]` markers with the user's answers
   - Replacing "To be defined" placeholders with specific content
   - Adding clarifications to ambiguous sections
   - Preserving the original structure and formatting

**Guidelines**:
- Limit to 3-5 questions per session to avoid overwhelming the user
- Focus on the most critical ambiguities first
- If focus areas are provided, prioritize questions related to those areas
- Each question should be independent and answerable
- Provide clear implications for each answer choice
- After updating spec.md, show a summary of what was clarified

After execution, spec.md will be updated with clarifications. The user can then proceed to `/blogkit.plan` to create a writing plan based on the clarified specification.

