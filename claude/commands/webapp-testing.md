Playwright MCPを使ってローカルアプリのUIをテストする。

# 前提条件

- 開発サーバーが起動していること（例: `pnpm dev`）
- Playwright MCPが設定済みであること

# 手順

## Step 1: プロジェクト情報の確認

1. `CLAUDE.md`を読み込み、プロジェクトの技術スタックを把握
2. 対象URLを確認（通常は http://localhost:4321 または http://localhost:3000）

## Step 2: 基本UI検査

以下を並列で実行:

1. **browser_navigate**でページを開く
2. **browser_take_screenshot**でデスクトップビューのフルページスクリーンショット撮影
3. **browser_console_messages**でJavaScriptエラーを確認

## Step 3: レスポンシブテスト

以下のビューポートで順次テスト:

### Desktop (1920x1080)
```
browser_resize({ width: 1920, height: 1080 })
browser_take_screenshot({ filename: "desktop.png" })
```

### Tablet (768x1024)
```
browser_resize({ width: 768, height: 1024 })
browser_take_screenshot({ filename: "tablet.png" })
```

### Mobile (375x667)
```
browser_resize({ width: 375, height: 667 })
browser_take_screenshot({ filename: "mobile.png" })
```

各サイズでレイアウト崩れやオーバーフローを確認。

## Step 4: アクセシビリティチェック

1. **browser_snapshot**でアクセシビリティツリーを取得
2. 以下を確認:
   - ボタンに適切な`aria-label`があるか
   - 見出しレベルが適切か（h1→h2→h3）
   - リンクテキストが明確か

## Step 5: CSS値の検証（オプション）

プロジェクトにデザインシステムがある場合、以下を確認:

```javascript
browser_evaluate({
  function: `() => {
    const button = document.querySelector('a[href*="contact"]');
    const styles = window.getComputedStyle(button);
    return {
      backgroundColor: styles.backgroundColor,
      padding: styles.padding,
      fontSize: styles.fontSize,
      borderRadius: styles.borderRadius
    };
  }`
})
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

### アクセシビリティ
- [問題点または「問題なし」]

### JavaScriptエラー
- [エラー内容または「エラーなし」]

### 推奨改善
1. [改善提案]
2. [改善提案]
```

# 注意事項

- サーバーが起動していない場合は明確にエラーを表示
- スクリーンショットは自動保存される（パスが返される）
- 重大な問題（レイアウト崩れ、エラー）は冒頭で強調
- 詳細は`docs/playwright-ui-testing.md`を参照
