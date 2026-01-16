---
name: start-issue
description: ".claude/commands/start-issue.md"
---

# Start Issue

Issue #$ARGUMENT の内容を確認して作業着手してください。

## 作業ルール

- 着手中の旨をIssueコメントに入力してください。
- issueと番号とタイトルからブランチ名を元にブランチをきって作業開始してください。
- 作業完了後はghコマンドを使ってPull Requestを提出してください。
  - 変更概要と意図がわかるように日本語で

```
# 解決したいこと
◯◯を解決したい

# 影響範囲
- A
- B

# TODO
- [ ] task X
- [ ] task Y
- [ ] task Z
```
