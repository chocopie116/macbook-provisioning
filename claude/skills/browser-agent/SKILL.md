---
name: browser-agent
description: "agent-browser CLIを使ってローカルアプリのUIをテストする。"
---

agent-browser CLIを使ってローカルアプリのUIをテストする。

# 前提条件

- agent-browserがインストール済み（`npm install -g agent-browser`）
- Chromiumダウンロード済み（`agent-browser install`）
- 開発サーバーが起動していること（例: `pnpm dev`）

# 手順

## Step 1: プロジェクト情報の確認

1. `CLAUDE.md`を読み込み、プロジェクトの技術スタックを把握
2. 対象URLを確認（通常は http://localhost:4321 または http://localhost:3000）

## Step 2: 基本UI検査

以下を順次実行:

1. **ページを開く**
```bash
agent-browser open <url>
```

2. **スクリーンショット撮影**
```bash
agent-browser screenshot --full-page
```

3. **要素スナップショット取得**（参照ID付き）
```bash
agent-browser snapshot -i
```

## Step 3: レスポンシブテスト

以下のビューポートで順次テスト:

### Desktop (1920x1080)
```bash
agent-browser viewport 1920 1080
agent-browser screenshot -o desktop.png
```

### Tablet (768x1024)
```bash
agent-browser viewport 768 1024
agent-browser screenshot -o tablet.png
```

### Mobile (375x667)
```bash
agent-browser viewport 375 667
agent-browser screenshot -o mobile.png
```

各サイズでレイアウト崩れやオーバーフローを確認。

## Step 4: インタラクションテスト

スナップショットで取得した参照ID（@e1, @e2など）を使用:

```bash
# 要素クリック
agent-browser click @e1

# テキスト入力
agent-browser type @e2 "テスト入力"

# スクロール
agent-browser scroll down 500
```

## Step 5: 情報取得

```bash
# テキスト取得
agent-browser text @e1

# HTML取得
agent-browser html @e1

# 属性値取得
agent-browser attr @e1 href
```

## Step 6: レポート作成

以下の形式でまとめる:

```markdown
## UI Test Report

### 概要
- 対象URL: [URL]
- テスト日時: [日時]

### デスクトップ (1920x1080)
- [問題点または「問題なし」]

### タブレット (768x1024)
- [問題点または「問題なし」]

### モバイル (375x667)
- [問題点または「問題なし」]

### インタラクション
- [動作確認結果]

### 推奨改善
1. [改善提案]
2. [改善提案]
```

# 便利なオプション

- `--headed`: ブラウザウィンドウを表示（デバッグ用）
- `--json`: JSON形式で出力
- `--session <name>`: セッション名を指定

# 注意事項

- サーバーが起動していない場合は明確にエラーを表示
- スクリーンショットは `-o` で保存先を指定可能
- 参照ID（@ref）はスナップショット実行後に有効
