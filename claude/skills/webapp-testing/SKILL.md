---
name: webapp-testing
description: "Use this skill when you need to test local web applications with Playwright, verify frontend functionality, debug UI behavior, or capture screenshots of web pages."
---

# Web Application Testing

PlaywrightでローカルWebアプリのテスト・スクリーンショット・デバッグを実行。

## 概要

Playwright MCP Serverを使用して:
- フロントエンド機能の検証
- UIの動作デバッグ
- スクリーンショット撮影
- コンソールログ取得

## 前提条件

### Playwright MCP Serverのインストール

```bash
# MCPサーバーをインストール
npm install -g @modelcontextprotocol/server-playwright

# または、npx経由で実行
npx -y @modelcontextprotocol/server-playwright
```

### Claude Code設定

`~/.claude/settings.json` にMCPサーバーを追加:
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

## 基本的な使い方

### 1. MCPツールをロード

```
MCPSearch tool で playwright ツールを検索
```

### 2. ブラウザを起動してナビゲート

```
mcp__playwright__browser_navigate を使用してページを開く
例: https://localhost:3000
```

### 3. ページの状態を確認

```
mcp__playwright__browser_snapshot でDOMのスナップショットを取得
または
mcp__playwright__browser_take_screenshot でスクリーンショットを撮影
```

### 4. 要素を操作

```
mcp__playwright__browser_click でボタンをクリック
mcp__playwright__browser_fill_form でフォームに入力
mcp__playwright__browser_type でテキストを入力
```

### 5. 検証

```
mcp__playwright__browser_console_messages でコンソールログを確認
mcp__playwright__browser_network_requests でネットワークリクエストを監視
```

## ワークフロー戦略

### 静的HTML

1. HTMLファイルを直接読み込んでCSSセレクタを特定
2. 自動化スクリプトを記述

### 動的Webアプリ

1. サーバーが起動しているか確認
2. 起動していない場合は、サーバーを起動
3. Reconaissance-then-Action:
   - ページにナビゲート
   - `networkidle` 状態まで待機
   - DOMスナップショットまたはスクリーンショットを撮影
   - セレクタを特定
   - アクションを実行

## 実装パターン

### ローカルサーバーの起動と同時実行

```bash
# 開発サーバーをバックグラウンドで起動
cd /path/to/app
npm run dev &
DEV_SERVER_PID=$!

# サーバーが起動するまで待機
sleep 5

# Playwright経由でテスト実行
# （Claude CodeでMCPツールを使用）

# 完了後、サーバーを停止
kill $DEV_SERVER_PID
```

### 複数サーバーの同時実行

```bash
# API サーバー
cd /path/to/api
npm start &
API_PID=$!

# フロントエンド サーバー
cd /path/to/frontend
npm run dev &
FRONTEND_PID=$!

# テスト実行後
kill $API_PID $FRONTEND_PID
```

## セレクタ戦略

### 推奨順序

1. **テキストベース**: `text=Login` （最も堅牢）
2. **Role-based**: `role=button[name="Submit"]`
3. **CSS**: `.submit-button`
4. **ID**: `#submit-btn`

### セレクタの例

```javascript
// テキストで検索
await page.click('text=Sign In');

// Roleで検索
await page.click('role=button[name="Submit"]');

// CSSセレクタ
await page.click('.btn-primary');

// IDセレクタ
await page.click('#login-btn');

// 複合セレクタ
await page.click('form.login-form >> button[type="submit"]');
```

## 待機戦略

### ネットワークアイドル待機（重要）

```
動的コンテンツがロードされる場合、必ず networkidle を待つ:
mcp__playwright__browser_wait_for を使用
```

### 要素の表示待機

```
特定の要素が表示されるまで待機:
selector: "button#submit"
state: "visible"
```

### タイムアウト設定

```
デフォルトタイムアウト: 30秒
長いロードが必要な場合はタイムアウトを調整
```

## よくあるテストシナリオ

### ログインフロー

```
1. browser_navigate: https://localhost:3000/login
2. browser_wait_for: networkidle
3. browser_fill_form: email, password
4. browser_click: role=button[name="Login"]
5. browser_wait_for: url contains "/dashboard"
6. browser_take_screenshot: verify success
```

### フォーム送信

```
1. browser_navigate: https://localhost:3000/form
2. browser_type: input#name, "John Doe"
3. browser_select_option: select#country, "Japan"
4. browser_click: button[type="submit"]
5. browser_console_messages: check for errors
6. browser_snapshot: verify success message
```

### SPA（Single Page Application）

```
1. browser_navigate: https://localhost:3000
2. browser_wait_for: networkidle
3. browser_click: nav a[href="/about"]
4. browser_wait_for: url contains "/about"
5. browser_snapshot: verify content loaded
```

### エラーハンドリング検証

```
1. browser_navigate: https://localhost:3000/form
2. browser_click: button[type="submit"]  # 空フォーム送信
3. browser_console_messages: check for validation errors
4. browser_snapshot: verify error messages displayed
```

## デバッグ技術

### コンソールログの監視

```
mcp__playwright__browser_console_messages
→ JavaScript エラー、警告、ログを確認
```

### ネットワークリクエストの監視

```
mcp__playwright__browser_network_requests
→ APIコール、失敗したリクエストを確認
```

### スクリーンショットでの検証

```
mcp__playwright__browser_take_screenshot
→ 視覚的な検証、レイアウト確認
```

### DOMスナップショット

```
mcp__playwright__browser_snapshot
→ HTML構造の確認、セレクタ特定
```

## トラブルシューティング

### ブラウザが起動しない
→ Playwright MCP Serverが正しくインストールされているか確認
```bash
npx @modelcontextprotocol/server-playwright --version
```

### 要素が見つからない
→ `browser_snapshot` でDOMを確認、セレクタを修正
→ `browser_wait_for` で要素の表示を待機

### タイムアウトエラー
→ ネットワークが遅い場合はタイムアウトを延長
→ `browser_wait_for` で明示的に待機

### サーバーに接続できない
→ サーバーが起動しているか確認: `curl http://localhost:3000`
→ ポート番号が正しいか確認

## ベストプラクティス

1. **常にnetworkidleを待つ**: 動的コンテンツのロード後にアクション実行
2. **堅牢なセレクタ**: テキストベースやRole-basedを優先
3. **適切な待機**: 明示的な待機で不安定なテストを回避
4. **スクリーンショットで検証**: 視覚的な確認を残す
5. **ブラウザを閉じる**: テスト完了後は `browser_close` を実行

## 参考

- Playwright公式ドキュメント: https://playwright.dev/
- Playwright MCP Server: https://github.com/modelcontextprotocol/servers
- セレクタガイド: https://playwright.dev/docs/selectors
