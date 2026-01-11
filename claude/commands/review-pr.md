Pull Request #$ARGUMENTS をレビューしてください。

# 手順

## Step 1: 情報収集

1. プロジェクトの CLAUDE.md を読み込み、コーディング規約や設計方針を把握する
2. `gh pr view $ARGUMENTS` でPR情報を取得
3. `gh pr diff $ARGUMENTS` で変更内容を取得

## Step 2: 並列レビュー

以下の5つのサブエージェントを **並列で** 実行し、それぞれの観点からレビューを行う。
各エージェントには Step 1 で取得した CLAUDE.md の内容を前提知識として提供すること。

1. **code-quality-reviewer**: コード品質と保守性
2. **performance-reviewer**: パフォーマンス最適化
3. **security-reviewer**: セキュリティ脆弱性
4. **test-coverage-reviewer**: テスト充足度
5. **documentation-reviewer**: ドキュメント正確性

## Step 3: レビュー結果の統合

各サブエージェントのレビュー結果を統合し、以下の形式でまとめる：

```markdown
## PR Review Summary

### Critical Issues
（重大な問題があれば記載）

### Security
（security-reviewer の結果）

### Code Quality
（code-quality-reviewer の結果）

### Performance
（performance-reviewer の結果）

### Test Coverage
（test-coverage-reviewer の結果）

### Documentation
（documentation-reviewer の結果）
```

## Step 4: コメント投稿

統合したレビュー結果を `gh pr comment $ARGUMENTS --body "..."` でPRにコメントとして投稿する。

# 注意事項

- PR番号が無効な場合は明確にエラーを表示する
- 指摘がない観点は「指摘事項なし」と簡潔に記載する
- 重大な問題（Critical/High）がある場合は冒頭で強調する
- 建設的なフィードバックを心がける
