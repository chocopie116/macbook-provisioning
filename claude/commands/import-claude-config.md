# Import Claude Config

macbook-provisioning リポジトリから Claude の設定ファイル（commands/agents）を作業中のリポジトリの `.claude/` ディレクトリにインポートします。

## 前提条件

- macbook-provisioning リポジトリのパス: `~/ghq/github.com/chocopie116/macbook-provisioning`
- コピー元: `~/ghq/github.com/chocopie116/macbook-provisioning/claude/{commands,agents}/*.md`
- コピー先: 作業中リポジトリの `.claude/{commands,agents}/`

## 実行手順

1. **検出**: macbook-provisioning の `claude/commands/*.md` と `claude/agents/*.md` を検出
2. **質問**: ユーザーにどのファイルをインポートするか質問（AskUserQuestion使用）
   - カテゴリ選択: commands, agents, または両方
   - 各カテゴリ内で個別ファイルを複数選択可能
3. **確認**: 各ファイルが作業中リポジトリの `.claude/` に既存かチェック
4. **エラー処理**: 既存ファイルがある場合はエラーメッセージを表示して終了
5. **コピー**: 選択されたファイルを `.claude/commands/` または `.claude/agents/` にコピー
   - 必要に応じて `.claude/commands/` と `.claude/agents/` ディレクトリを作成
6. **完了**: コピーしたファイル一覧を表示

## エラー条件

- 既存ファイルが1つでもある場合は処理を中断し、以下を表示：
  - 既存ファイルのパス一覧
  - 「先に既存ファイルを削除またはリネームしてください」というメッセージ

## 対象外

- settings.json
- スクリプトファイル（notify.sh, statusline.sh）
- CLAUDE.md

## 使用例

```bash
# 別のプロジェクトで実行（例: /path/to/my-project）
cd /path/to/my-project
/import-claude-config

# 質問に答える
# → "commands と agents のどちらをインポートしますか？"
# → "commands の中でどのファイルをインポートしますか？"（複数選択可）
# → "agents の中でどのファイルをインポートしますか？"（複数選択可）

# 結果
# ✓ Copied: .claude/commands/review-pr.md
# ✓ Copied: .claude/agents/security-reviewer.md
# ...
```
