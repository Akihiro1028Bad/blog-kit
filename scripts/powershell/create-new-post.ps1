# create-new-post.ps1
# Creates a new blog post directory structure with spec.md

param(
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [string[]]$FeatureDesc
)

$ErrorActionPreference = "Stop"

# Join description arguments
$Description = $FeatureDesc -join " "

if ([string]::IsNullOrWhiteSpace($Description)) {
    Write-Error "Error: Article description is required"
    Write-Host "Usage: create-new-post.ps1 'Article description'"
    exit 1
}

# Get repository root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$BlogkitDir = Join-Path $RepoRoot ".blogkit"
$PostsDir = Join-Path $RepoRoot "posts"
$TemplatesDir = Join-Path $BlogkitDir "templates"

# Find next article number
$NextNum = 1
if (Test-Path $PostsDir) {
    Get-ChildItem -Path $PostsDir -Directory | ForEach-Object {
        $Basename = $_.Name
        if ($Basename -match '^(\d+)') {
            $Num = [int]$Matches[1]
            if ($Num -ge $NextNum) {
                $NextNum = $Num + 1
            }
        }
    }
}

# Format article number (001, 002, etc.)
$ArticleNum = "{0:D3}" -f $NextNum

# Generate short name from description
$Words = $Description.ToLower() -replace '[^a-z0-9 ]', '' -split ' ' | 
    Where-Object { $_.Length -ge 3 -and $_ -notmatch '^(the|and|for|are|but|not|you|all|can|her|was|one|our|out|day|get|has|him|his|how|man|new|now|old|see|two|way|who|boy|did|its|let|put|say|she|too|use)$' } | 
    Select-Object -First 4

$ShortName = ($Words -join '-')
if ([string]::IsNullOrWhiteSpace($ShortName)) {
    $ShortName = "article"
}

# Limit length
if ($ShortName.Length -gt 50) {
    $ShortName = $ShortName.Substring(0, 50)
}

# Create directory name
$DirName = "$ArticleNum-$ShortName"
$PostDir = Join-Path $PostsDir $DirName

# Create directory structure
New-Item -ItemType Directory -Path $PostDir -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $PostDir "assets") -Force | Out-Null

# Get current date
$CreatedDate = Get-Date -Format "yyyy-MM-dd"

# Create spec.md from template
$SpecFile = Join-Path $PostDir "spec.md"
$Title = if ($Description.Length -gt 100) { $Description.Substring(0, 100) } else { $Description }

if (Test-Path (Join-Path $TemplatesDir "spec-template.md")) {
    $Template = Get-Content (Join-Path $TemplatesDir "spec-template.md") -Raw
    $Template = $Template -replace '\{ARTICLE_TITLE\}', $Title
    $Template = $Template -replace '\{ARTICLE_NUMBER\}', $ArticleNum
    $Template = $Template -replace '\{CREATED_DATE\}', $CreatedDate
    $Template = $Template -replace '\{ARTICLE_THEME\}', $Description
    $Template = $Template -replace '\{TARGET_AUDIENCE\}', "To be defined"
    $Template = $Template -replace '\{CONTENT_STRUCTURE\}', "To be defined"
    $Template = $Template -replace '\{KEY_POINTS\}', "To be defined"
    $Template = $Template -replace '\{SUCCESS_CRITERIA\}', "To be defined"
    $Template = $Template -replace '\{NOTES\}', ""
    $Template | Set-Content $SpecFile
} else {
    # Create basic spec.md if template doesn't exist
    $Content = @"
# Article Specification: $Title

**Article Number**: $ArticleNum
**Created**: $CreatedDate
**Status**: Draft

## Article Theme
$Description

## Target Audience
To be defined

## Content Structure
To be defined

## Key Points
To be defined

## Success Criteria
To be defined
"@
    $Content | Set-Content $SpecFile
}

# Output JSON for command integration
$Output = @{
    ARTICLE_NUM = $ArticleNum
    DIR_NAME = $DirName
    POST_DIR = $PostDir
    SPEC_FILE = $SpecFile
} | ConvertTo-Json

Write-Output $Output

