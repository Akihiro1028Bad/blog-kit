# BlogKit

Spec-Kit風のブログ執筆支援ツール。エディタのスラッシュコマンドとして提供され、仕様駆動のブログ執筆ワークフローを実現します。

## 概要

BlogKitは、GitHubのSpec-Kitを参考にしたブログ執筆支援ツールです。以下のワークフローを提供します：

1. **`/blogkit.specify`** - 記事の仕様を作成
2. **`/blogkit.clarify`** - 仕様の曖昧さを解決し、要件を詰める
3. **`/blogkit.plan`** - 執筆計画を作成
4. **`/blogkit.tasks`** - 執筆タスクに分解
5. **`/blogkit.write`** - 記事を執筆（AI支援）
6. **`/blogkit.publish`** - 公開準備

## 初期化

プロジェクトを初期化するには：

```bash
./scripts/bash/blogkit-init.sh
```

または、既に初期化されている場合は、エディタのコマンドを直接使用できます。

## 使用方法

### 1. 記事仕様の作成

エディタで以下のコマンドを実行：

```
/blogkit.specify TypeScriptの型安全性について解説する記事を書きたい。初心者向けに、基本的な型の使い方から、高度な型操作まで段階的に説明する。
```

これにより、`posts/001-typescript-type-safety/`ディレクトリが作成され、`spec.md`が生成されます。

### 2. 仕様の明確化（オプション）

```
/blogkit.clarify
```

または、特定の領域にフォーカスする場合：

```
/blogkit.clarify Focus on target audience and content structure
```

`spec.md`の曖昧な点や未定義の項目を特定し、対話的に要件を詰めます。AIが質問を生成し、ユーザーの回答に基づいて`spec.md`を更新します。

### 3. 執筆計画の作成

```
/blogkit.plan コード例はTypeScriptで記述。実践的なサンプルを3-4個含める。図表は不要。初心者にもわかりやすい説明を心がける。
```

`plan.md`が生成されます。

### 4. タスク分解

```
/blogkit.tasks
```

`tasks.md`が生成され、執筆タスクが分解されます。

### 5. 記事執筆

```
/blogkit.write
```

AI支援により、`article.md`が生成されます。

### 6. 公開準備

```
/blogkit.publish
```

記事の最終チェックとメタデータ生成が行われます。

## ディレクトリ構造

```
blog/
├── .blogkit/                    # BlogKit設定
│   ├── memory/
│   │   └── constitution.md      # 執筆原則
│   └── templates/               # テンプレート
├── posts/                       # ブログ記事
│   └── 001-article-title/
│       ├── spec.md              # 記事仕様
│       ├── plan.md              # 執筆計画
│       ├── tasks.md             # タスク分解
│       ├── article.md           # 実際の記事
│       └── assets/              # アセット
├── scripts/                     # スクリプト
│   ├── bash/
│   └── powershell/
└── .cursor/                     # エディタ統合
    └── commands/
```

## 対応エディタ

- Cursor (`.cursor/commands/`)
- Claude Code (`.claude/commands/`)
- GitHub Copilot (`.github/prompts/`)

## ライセンス

MIT

