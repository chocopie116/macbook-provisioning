---
name: obsidian-daily-review
description: "Carry over incomplete tasks and context from yesterday's Obsidian daily note to today"
allowed-tools:
  - Read
  - Write
  - Bash
---

# Obsidian Daily Review

Obsidianのデイリーノートで、昨日の未完了タスクと進行中コンテキストを今日に引き継ぐスキル。

## 概要

毎朝のルーチンとして、昨日のデイリーノート（YYYY-MM-DD.md）から以下を抽出し、今日のノートの `## Tasks` セクションに挿入する：

- 未完了タスク (`- [ ]`)
- 進行中のプロジェクト/コンテキスト（リンクや継続中の作業メモ）

手動順序を尊重し、自動的な並び替えは行わない。

## 依存ツール

- Python 3.8+
- 環境変数: `OBSIDIAN_VAULT_PATH`

## セットアップ

### 1. スキルのリンク

このリポジトリをクローン済みの場合：

```bash
make link/claude
```

### 2. 環境変数設定

`~/.zshrc` に以下を追加：

```bash
export OBSIDIAN_VAULT_PATH="/path/to/your/obsidian/vault"
```

設定後、反映：

```bash
source ~/.zshrc
```

### 3. デイリーノート形式

以下の形式に従うこと：

```markdown
# 2026-01-13

## Tasks
- [ ] 未完了タスク1
- [x] 完了済みタスク
- [ ] 未完了タスク2

## Notes
進行中のプロジェクト: [[Project A]]の設計レビュー継続中
```

**必須**:
- ファイル名: `YYYY-MM-DD.md` (例: 2026-01-13.md)
- セクション: `## Tasks` が存在すること

## 使い方

### 基本操作

```bash
/obsidian-daily-review
```

Claude Codeが以下を自動実行：

1. 昨日のノート（例: 2026-01-12.md）を読み込み
2. 未完了タスク (`- [ ]`) を抽出
3. 進行中コンテキスト（リンク、継続中項目）を抽出
4. 今日のノート（例: 2026-01-13.md）の `## Tasks` セクションに挿入

### 出力例

**昨日のノート (2026-01-12.md)**:
```markdown
## Tasks
- [ ] レポート作成
- [x] ミーティング参加
- [ ] コードレビュー

## Notes
[[Project X]] のAPI設計を継続中
```

**今日のノート (2026-01-13.md) への挿入後**:
```markdown
## Tasks
<!-- Carried over from 2026-01-12 -->
- [ ] レポート作成
- [ ] コードレビュー
- [ ] [[Project X]] のAPI設計を継続

(既存のタスクがあればその下に追加)
```

## エラーハンドリング

### エラー: "OBSIDIAN_VAULT_PATH not set"
→ 環境変数を設定してください（セットアップ参照）

### エラー: "Today's note not found"
→ 今日のノート（YYYY-MM-DD.md）を先に作成してください

### エラー: "Yesterday's note not found"
→ 正常。昨日のノートがない場合はスキップ

### エラー: "## Tasks section not found"
→ 今日のノートに `## Tasks` セクションを追加してください

## 制約事項

- Obsidian標準のチェックボックス形式 (`- [ ]` / `- [x]`) のみ対応
- `## Tasks` セクション名は固定（大文字小文字区別）
- 手動順序を維持（自動並び替えなし）
- タグベースの優先度管理には非対応

## カスタマイズ

### セクション名を変更したい場合

`scripts/review.py` の `TASKS_SECTION` を編集：

```python
TASKS_SECTION = "## タスク"  # デフォルト: "## Tasks"
```

### 引き継ぐパターンを追加したい場合

`scripts/review.py` の `extract_context()` 関数を編集してパターンを追加。

## 参考

- [Obsidian公式ドキュメント](https://help.obsidian.md/)
- [Claude Code Skills作成ガイド](https://code.claude.com/docs/en/skills)
