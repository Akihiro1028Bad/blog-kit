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

**AI Processing - CRITICAL: Interactive One-by-One Flow**:
After the script runs, the AI MUST follow this interactive flow:

1. Read the full spec.md content
2. Identify all ambiguities and undefined areas (prioritize up to 3-5 most critical)
3. **Present ONLY Question 1** to the user (see format below)
4. **WAIT for user's response** - do NOT proceed until user answers
5. After receiving the answer:
   - Parse the response (single letter A/B/C or "Custom - [description]")
   - Update spec.md immediately with Question 1's answer
   - **Then present Question 2** (if more questions exist)
6. Repeat steps 3-5 for each remaining question
7. After all questions are answered, show a summary of clarifications

**Question Format** (present ONE at a time):
---
## Question 1 of [Total]: [Topic]

**Context**: [Where this appears in spec.md, including line number or section]
**What we need to know**: [What information is needed]

**Suggested Answers**:
| Option | Answer | Implications |
|--------|--------|--------------|
| A | [Option A description] | [What this choice means for the article] |
| B | [Option B description] | [What this choice means for the article] |
| C | [Option C description] | [What this choice means for the article] |
| Custom | Your own approach | [Describe your preference] |

**Your choice**: _[Wait for user response - DO NOT proceed until answered]_
---

**Answer Format**:
- User responds with: "A", "B", "C", or "Custom - [description]"
- **DO NOT** ask for multiple answers at once
- **DO NOT** present the next question until the current one is answered

**spec.md Update Strategy**:
- **Recommended**: Update spec.md after each question is answered
  - This allows the user to see progress incrementally
  - Each update replaces one "To be defined" or `[NEEDS CLARIFICATION]` marker
- Preserve the original structure and formatting when updating

**Critical Guidelines**:
- **ONE QUESTION AT A TIME**: Never present multiple questions simultaneously
- **WAIT FOR RESPONSE**: Always wait for user input before proceeding
- **IMMEDIATE UPDATES**: Update spec.md after each answer (recommended)
- **PROGRESS INDICATION**: Show which question number you're on (e.g., "Question 1 of 3")
- **SESSION LIMIT**: Limit to 3-5 questions per session to avoid overwhelming the user
- Focus on the most critical ambiguities first
- If focus areas are provided, prioritize questions related to those areas
- Each question should be independent and answerable
- Provide clear implications for each answer choice
- After all questions are answered, show a summary of what was clarified

After execution, spec.md will be updated with clarifications. The user can then proceed to `/blogkit.plan` to create a writing plan based on the clarified specification.

