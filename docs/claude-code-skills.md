# Claude Code Skills 作成ガイド

Claude Code の機能を拡張する「スキル」の作り方。

## スキルとは

特定ドメインの知識・ワークフロー・ツール統合を提供するモジュール型パッケージ。
`~/.claude/skills/` または `.claude/commands/` に配置する。

## 必須ファイル構造

```
my-skill/
├── SKILL.md          # 必須: メタデータ + 使い方
├── scripts/          # オプション: 実行スクリプト
├── references/       # オプション: 詳細ドキュメント
└── assets/           # オプション: テンプレート等
```

### SKILL.md の基本構造

```markdown
---
name: skill-name
description: "15-80文字の具体的説明（何ができるか）"
allowed-tools:
  - Read
  - Write
  - Bash
---

# Skill Name

## 概要
スキルの目的と使い所。

## 依存ツール
- Python 3.8+
- pdfplumber: `pip install pdfplumber`

## 基本操作
### 操作1
\`\`\`bash
command example
\`\`\`

## トラブルシューティング
### エラー: "Module not found"
→ `pip install -r requirements.txt`

## 参考
- 公式ドキュメント: https://example.com
```

## 作成手順（6ステップ）

### 1. 具体例で理解
- ユーザーが何をしたいのか？
- どのような入力を与えるのか？
- 期待される出力は？

### 2. コンテンツ計画
- スクリプト: 繰り返し実行される操作
- リファレンス: 詳細ドキュメント（API仕様等）
- アセット: テンプレートファイル

### 3. 初期化
```bash
mkdir -p ~/.claude/skills/my-skill/{scripts,references,assets}
cd ~/.claude/skills/my-skill
touch SKILL.md
```

### 4. SKILL.md 編集
- 命令形・不定詞形を使用（"Do X" "To achieve Y"）
- 客観的・説明的
- SKILL.md は簡潔に、詳細は references/ へ

### 5. パッケージ化（オプション）
```bash
tar -czf my-skill.claude-skill -C ~/.claude/skills/my-skill .
```

### 6. イテレーション
実際の使用でテストし改善。

## 設計原則

### Progressive Disclosure（段階的開示）

スキルは3段階でロード:
1. **メタデータ**: 常に利用可能（description）
2. **SKILL.md本体**: スキルがトリガーされた時
3. **バンドルリソース**: 必要に応じて

### 良い description の書き方

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
- 3人称視点で記述（"Use this skill when..."）
- 15-80文字

### 命令型言語を使う

**悪い例**:
```markdown
You should probably install the dependencies first.
```

**良い例**:
```markdown
Install dependencies:
\`\`\`bash
pip install -r requirements.txt
\`\`\`
```

## ベストプラクティス

### 1. 依存関係を明記
```markdown
## 依存ツール
- Python 3.8+
- pdfplumber: `pip install pdfplumber`
- poppler: `brew install poppler`
```

### 2. エラーハンドリングを記載
```markdown
## トラブルシューティング
### エラー: "Module not found"
→ `pip install -r requirements.txt`

### エラー: "Permission denied"
→ `chmod +x scripts/run.sh`
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
- references/api.md for detailed API documentation
```

## スキル配置

### ローカル配置
```bash
# シンボリックリンクで配置
ln -s ~/ghq/github.com/user/my-skill ~/.claude/commands/my-skill.md
```

### GitHub 共有
```bash
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
name: skill-name
description: "One-line description"
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
name: skill-name
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

## 参考リソース

- [Agent Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [GitHub - anthropics/skills: Public repository for Agent Skills](https://github.com/anthropics/skills)
- [How to create custom Skills | Claude Help Center](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)
- [Claude Skills and CLAUDE.md: a practical 2026 guide for teams](https://www.gend.co/blog/claude-skills-claude-md-guide)
- [awesome-claude-skills](https://github.com/VoltAgent/awesome-claude-skills)
