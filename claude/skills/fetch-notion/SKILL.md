---
name: fetch-notion
description: "Notionデータベースからデータを取得"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Notion DB取得

任意のNotionデータベースからページ一覧・内容を取得する汎用スキル。

## 前提条件

- 環境変数 `NOTION_API_KEY` が設定されていること
- NotionデータベースにIntegrationが接続されていること

## 登録済みDB

`databases.yaml` に定義:

- **打ち合わせ**: ミーティング議事録
- **コンタクト**: 連絡先
- **会社**: 会社情報
- **案件**: 案件管理

## コマンド

```bash
cd claude/skills/fetch-notion

# 登録済みDB一覧
bun run fetch-notion.ts --list

# DBスキーマ確認
bun run fetch-notion.ts 打ち合わせ --schema

# ページ一覧取得
bun run fetch-notion.ts 打ち合わせ

# 件数制限
bun run fetch-notion.ts 打ち合わせ --limit 5

# 簡潔出力（ID + タイトルのみ、タブ区切り）
bun run fetch-notion.ts 打ち合わせ --brief

# 組み合わせ
bun run fetch-notion.ts 打ち合わせ --brief --limit 3

# ページ内容取得（Markdown形式）
bun run fetch-notion.ts --page PAGE_ID
```

## AIエージェント向け使い分け

| 用途 | コマンド |
|------|----------|
| 最新数件を素早く確認 | `--brief --limit 3` |
| ページIDを取得したい | `--brief` |
| 詳細情報が必要 | オプションなし |
| 特定ページの全内容 | `--page PAGE_ID` |

## DBの追加方法

`databases.yaml` を編集:

```yaml
databases:
  新しいDB名:
    id: "notion-database-id"
    description: "説明"
```

NotionのDB URLから ID を取得:
`https://www.notion.so/xxxxx?v=yyyyy` → `xxxxx` がID

## 出力形式

### ページ一覧

```
- ミーティングタイトル
  ID: xxx-xxx-xxx
  URL: https://notion.so/...
  Properties: 日付: 2025-01-16 | 会社: ABC Corp
```

### ページ内容

Markdown形式で出力（見出し、リスト、コード、引用など対応）

## 応答スタイル

- 簡潔に
- 日本語で応答
