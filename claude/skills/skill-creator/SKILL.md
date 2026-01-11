---
name: skill-creator
description: "Use this skill when you need to create a new Claude Skill, understand skill structure and best practices, or set up skill files and directories."
---

# Skill Creator

新しいClaude Skillを作成するためのガイドライン。

## スキルとは

スキルは、Claudeに特定ドメインの知識・ワークフロー・ツール統合を提供するモジュール型パッケージ。

## スキルの構造

### 必須ファイル

**SKILL.md** (または skill-name.md):
```markdown
---
description: "Brief description of what this skill does"
allowed-tools:
  - Read
  - Write
  - Bash
  - (必要なツール)
---

# Skill Name

## 概要
[スキルの目的]

## 使い方
[具体的な手順]

## 注意事項
[依存関係や制限事項]
```

### オプションリソース

- **scripts/**: 実行可能なコード（再利用可能な決定論的タスク用）
- **references/**: 必要に応じてロードされるドキュメント
- **assets/**: テンプレート、アイコン、フォント等

## 作成プロセス（6ステップ）

### 1. 具体例で理解

実際のユースケースを収集:
```
- ユーザーが何をしたいのか？
- どのような入力を与えるのか？
- 期待される出力は？
```

### 2. コンテンツ計画

必要なリソースを特定:
- スクリプト: 繰り返し実行される操作
- リファレンス: 詳細ドキュメント（API仕様等）
- アセット: テンプレートファイル

### 3. 初期化

```bash
mkdir -p ~/.claude/skills/my-skill
cd ~/.claude/skills/my-skill
touch SKILL.md
mkdir -p scripts references assets
```

### 4. 編集

**SKILL.mdの書き方**:
- 命令形・不定詞形を使用（"Do X" "To achieve Y"）
- 客観的・説明的な言語
- SKILL.mdは簡潔に、詳細はリファレンスファイルへ
- 重複を避ける

**例**:
```markdown
---
description: "Process PDFs to extract text and tables"
allowed-tools:
  - Read
  - Bash
---

# PDF Processor

Extract text and tables from PDF files using pdfplumber.

## Usage

1. Install dependencies:
   ```bash
   pip install pdfplumber
   ```

2. Extract text:
   ```bash
   python scripts/extract_text.py input.pdf
   ```

3. Extract tables:
   ```bash
   python scripts/extract_tables.py input.pdf output.xlsx
   ```

## Dependencies

- Python 3.8+
- pdfplumber

## See Also

- references/api.md for detailed API documentation
```

### 5. パッケージ化

（オプション）配布用にパッケージング:
```bash
# .claude-skillとしてパッケージ化
tar -czf my-skill.claude-skill -C ~/.claude/skills/my-skill .
```

### 6. イテレーション

実際の使用でテストし、改善:
- 不足している情報は？
- 手順は明確か？
- エラーハンドリングは十分か？

## 設計原則

### Progressive Disclosure（段階的開示）

スキルは3段階でロード:
1. **メタデータ**: 常に利用可能（description）
2. **SKILL.md本体**: スキルがトリガーされた時
3. **バンドルリソース**: 必要に応じて

### 良いdescriptionの書き方

**悪い例**:
```yaml
description: "PDF tool"
```

**良い例**:
```yaml
description: "Extract text, tables, metadata, merge & annotate PDFs"
```

ポイント:
- 具体的に何ができるか
- 3人称視点で記述（"This skill should be used when..."）
- 15-80文字

### 命令型言語

**悪い例**:
```markdown
You should probably install the dependencies first.
```

**良い例**:
```markdown
Install dependencies:
```bash
pip install -r requirements.txt
```
```

## 既存スキルを参考にする

```bash
# 既存スキルを確認
ls ~/.claude/commands/

# スキルを読む
cat ~/.claude/commands/pdf.md
```

## ベストプラクティス

### 1. 依存関係を明記

```markdown
## 依存ツール

- Python 3.8+
- pdfplumber: `pip install pdfplumber`
- poppler: `brew install poppler`
```

### 2. エラーハンドリング

```markdown
## トラブルシューティング

### エラー: "Module not found"
→ 依存関係をインストール: `pip install -r requirements.txt`

### エラー: "Permission denied"
→ 実行権限を付与: `chmod +x scripts/run.sh`
```

### 3. 例を豊富に

```markdown
## 例

### 基本的な使い方
\`\`\`bash
python scripts/process.py input.txt
\`\`\`

### 高度な使い方
\`\`\`bash
python scripts/process.py --format json --output result.json input.txt
\`\`\`
```

### 4. 参照を追加

```markdown
## 参考

- Official docs: https://example.com/docs
- Tutorial: https://example.com/tutorial
- references/api.md for detailed API documentation
```

## スキル配布

### ローカル配置

```bash
# シンボリックリンクで配置
ln -s ~/ghq/github.com/user/my-skill ~/.claude/commands/my-skill.md
```

### GitHub共有

```bash
# リポジトリ作成
cd ~/.claude/commands
git init
git add my-skill.md
git commit -m "Add my-skill"
git remote add origin https://github.com/user/claude-skills
git push -u origin main
```

## テンプレート

### 最小限のスキル

```markdown
---
description: "One-line description of the skill"
allowed-tools:
  - Read
  - Write
---

# Skill Name

Brief overview.

## Usage

Step-by-step instructions.

## Dependencies

List of required tools/libraries.
```

### フルスキル

```markdown
---
description: "Comprehensive description"
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
  - Glob
---

# Skill Name

Detailed overview.

## 概要
What this skill does and why it's useful.

## 依存ツール
- Tool 1: Installation instructions
- Tool 2: Installation instructions

## 基本操作
### Operation 1
Code example

### Operation 2
Code example

## 高度な操作
Advanced use cases

## トラブルシューティング
Common issues and solutions

## 参考
Links to documentation
```

## 参考

- Claude Code公式ドキュメント: https://docs.anthropic.com/claude-code
- awesome-claude-skills: https://github.com/ComposioHQ/awesome-claude-skills
