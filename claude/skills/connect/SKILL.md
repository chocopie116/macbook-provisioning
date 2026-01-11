---
name: connect
description: "Use this skill when you need to connect Claude to external services like Gmail, Slack, GitHub, Notion, or any of 1000+ supported apps to send emails, create issues, post messages, or update databases."
---

# Connect

ClaudeをGmail、Slack、GitHub、Notion等1000+のサービスに接続し、実際のアクションを実行。

## 概要

Connectスキルは、Claudeをテキスト生成ツールからアクション実行エンジンに変換:
- メール送信
- Issue作成
- メッセージ投稿
- データベース更新
- ファイル操作
- タスク管理

OAuthは自動処理され、初回認証後は永続的に接続を維持。

## 対応サービス

### コミュニケーション
- Gmail, Outlook
- Slack, Discord, Microsoft Teams
- Zoom, Google Meet

### 開発
- GitHub, GitLab, Bitbucket
- Jira, Linear
- Sentry, Datadog

### ドキュメント
- Notion, Google Docs, Confluence
- Dropbox, Google Drive, Box

### データベース
- Airtable, Google Sheets
- PostgreSQL, MySQL（Composio経由）

### その他
- Salesforce, HubSpot
- Trello, Asana, Todoist
- Twitter, LinkedIn

## セットアップ

### 1. Composio APIキーの取得

1. https://platform.composio.dev にアクセス
2. 無料アカウント作成
3. APIキーをコピー

### 2. 環境変数の設定

```bash
# ~/.zshrc または ~/.bashrc
export COMPOSIO_API_KEY="your-api-key-here"

# 反映
source ~/.zshrc
```

### 3. インストール

#### Python
```bash
pip install composio-core
```

#### Node.js
```bash
npm install -g composio-core
```

### 4. 動作確認

```bash
composio --version
```

## 基本的な使い方

### アプリの接続

```bash
# 利用可能なアプリを確認
composio apps

# アプリを接続（ブラウザが開いてOAuth認証）
composio login gmail
composio login slack
composio login github
```

### 接続状態の確認

```bash
# 接続済みアプリを一覧表示
composio integrations
```

## 実用例

### Gmail: メール送信

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# メール送信
result = toolset.execute_action(
    action="GMAIL_SEND_EMAIL",
    params={
        "to": "recipient@example.com",
        "subject": "Meeting Tomorrow",
        "body": "Hi, let's meet at 10am tomorrow."
    }
)
print(result)
```

Claude Code経由:
```
Send an email to sarah@acme.com with subject "Project Update" and body "The feature is ready for review."
```

### Slack: メッセージ投稿

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# チャンネルに投稿
result = toolset.execute_action(
    action="SLACK_POST_MESSAGE",
    params={
        "channel": "#engineering",
        "text": "Deploy completed successfully! 🚀"
    }
)
```

Claude Code経由:
```
Post to #engineering: "Deploy complete! 🚀"
```

### GitHub: Issue作成

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# Issue作成
result = toolset.execute_action(
    action="GITHUB_CREATE_ISSUE",
    params={
        "owner": "my-org",
        "repo": "my-repo",
        "title": "Fix login timeout bug",
        "body": "Users are experiencing timeouts on mobile login after 30 seconds.",
        "labels": ["bug", "high-priority"]
    }
)
```

Claude Code経由:
```
Create GitHub issue in my-org/repo: "Fix mobile login timeout - users experience 30s delays"
```

### Notion: ページ作成

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# ページ作成
result = toolset.execute_action(
    action="NOTION_CREATE_PAGE",
    params={
        "parent_page_id": "abc123",
        "title": "Q1 Planning",
        "content": "Goals for Q1:\n- Launch feature X\n- Improve performance by 20%"
    }
)
```

### Google Sheets: データ追加

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# スプレッドシートに行追加
result = toolset.execute_action(
    action="GOOGLESHEETS_APPEND_ROW",
    params={
        "spreadsheet_id": "1abc...",
        "sheet_name": "Sales",
        "values": ["2024-01-15", "Product A", 150, 22500]
    }
)
```

## 複合アクション

### メール読んでSlack通知

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# 1. 未読メールを取得
emails = toolset.execute_action(
    action="GMAIL_GET_UNREAD_EMAILS",
    params={"max_results": 5}
)

# 2. 重要なメールをSlackに通知
for email in emails["data"]:
    if "urgent" in email["subject"].lower():
        toolset.execute_action(
            action="SLACK_POST_MESSAGE",
            params={
                "channel": "#alerts",
                "text": f"Urgent email from {email['from']}: {email['subject']}"
            }
        )
```

### GitHubイベントをNotionに記録

```python
from composio import ComposioToolSet

toolset = ComposioToolSet()

# 1. 最近のPRを取得
prs = toolset.execute_action(
    action="GITHUB_LIST_PULL_REQUESTS",
    params={
        "owner": "my-org",
        "repo": "my-repo",
        "state": "open"
    }
)

# 2. Notionデータベースに追加
for pr in prs["data"]:
    toolset.execute_action(
        action="NOTION_CREATE_DATABASE_ENTRY",
        params={
            "database_id": "xyz789",
            "title": pr["title"],
            "url": pr["html_url"],
            "status": "In Review"
        }
    )
```

## Claude Agent SDKとの統合

```python
from anthropic import Anthropic
from composio import ComposioToolSet

client = Anthropic()
toolset = ComposioToolSet()

# Composioツールを取得
tools = toolset.get_tools(actions=["GMAIL_SEND_EMAIL", "SLACK_POST_MESSAGE"])

# Claudeにツールを提供
response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    tools=tools,
    messages=[{
        "role": "user",
        "content": "Send a summary email to team@example.com and post to #general"
    }]
)
```

## トラブルシューティング

### OAuth認証エラー
→ `composio logout <app>` 後、再度 `composio login <app>` を実行

### APIキーエラー
→ 環境変数 `COMPOSIO_API_KEY` が設定されているか確認
```bash
echo $COMPOSIO_API_KEY
```

### ツールが見つからない
→ アプリが接続済みか確認: `composio integrations`

### パーミッションエラー
→ OAuth認証時に必要な権限が許可されているか確認

## セキュリティのベストプラクティス

1. **APIキーを共有しない**: 個人アカウントのみ使用
2. **最小権限の原則**: 必要な権限のみ付与
3. **定期的なレビュー**: 使用していない接続を削除
4. **環境変数管理**: .envファイルは.gitignoreに追加

```bash
# .gitignore
.env
```

## 利用可能なアクション一覧

### Gmail
- `GMAIL_SEND_EMAIL`: メール送信
- `GMAIL_GET_UNREAD_EMAILS`: 未読メール取得
- `GMAIL_SEARCH_EMAILS`: メール検索
- `GMAIL_CREATE_DRAFT`: 下書き作成

### Slack
- `SLACK_POST_MESSAGE`: メッセージ投稿
- `SLACK_LIST_CHANNELS`: チャンネル一覧
- `SLACK_CREATE_CHANNEL`: チャンネル作成
- `SLACK_INVITE_USER`: ユーザー招待

### GitHub
- `GITHUB_CREATE_ISSUE`: Issue作成
- `GITHUB_CREATE_PULL_REQUEST`: PR作成
- `GITHUB_LIST_REPOSITORIES`: リポジトリ一覧
- `GITHUB_MERGE_PULL_REQUEST`: PRマージ

### Notion
- `NOTION_CREATE_PAGE`: ページ作成
- `NOTION_UPDATE_PAGE`: ページ更新
- `NOTION_SEARCH`: 検索
- `NOTION_CREATE_DATABASE`: データベース作成

詳細: `composio actions <app>` で確認

## 参考

- Composio公式: https://docs.composio.dev/
- サポートアプリ一覧: https://docs.composio.dev/apps
- Claude Agent SDK: https://github.com/anthropics/anthropic-sdk-python
