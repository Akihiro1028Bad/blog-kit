---
description: "Prepare the article for publication (final checks and metadata)"
---

Prepare the article for publication by performing final checks and generating publication metadata.

The command:
1. Validates the article is complete
2. Generates or updates frontmatter metadata
3. Creates slug from title
4. Suggests tags and categories
5. Generates excerpt if missing

**Usage**: `/blogkit.publish`

**Script**: `scripts/bash/publish-article.sh`

Execute: `scripts/bash/publish-article.sh --json`

The script will:
1. Detect the current article directory (from git branch or SPECIFY_FEATURE env var)
2. Read article.md from the article directory
3. Validate article completeness:
   - Check for required frontmatter fields
   - Verify article has content
   - Check for broken links (if applicable)
4. Generate/update metadata:
   - Slug (URL-friendly version of title)
   - Publication date
   - Tags (suggest based on content)
   - Categories (suggest based on content)
   - Excerpt (if not provided)
5. Update article.md with complete frontmatter

After execution, the article will be ready for publication. The user can review the metadata and make final edits before publishing.

