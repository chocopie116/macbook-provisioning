---
name: skill-share
description: "Use this skill when you need to package a Claude Skill for distribution, share skills with your team via Slack, or set up a team skill repository."
---

# Skill Share

Claude Skillを作成し、Slack経由でチームに自動配布する。

## 概要

skill-shareは、Claude Skillの開発からチーム通知までのワークフローを効率化:
1. 構造化されたスキルディレクトリを生成
2. メタデータ検証
3. 配布可能パッケージ化
4. Slack経由でチーム通知

## 前提条件

- Slackワークスペースへのアクセス
- ファイルシステム書き込み権限
- Python 3.7+

## 基本的な使い方

### 1. 新しいスキルを作成

```bash
mkdir -p ~/.claude/skills/my-new-skill
cd ~/.claude/skills/my-new-skill

# SKILL.mdを作成
cat > SKILL.md << 'EOF'
---
description: "Brief description of the skill"
allowed-tools:
  - Read
  - Write
---

# My New Skill

## 概要
What this skill does.

## 使い方
1. Step 1
2. Step 2

## 依存関係
- Dependency 1
- Dependency 2
EOF
```

### 2. スキルディレクトリを初期化

```bash
# scripts/ディレクトリ
mkdir -p scripts

# サンプルスクリプト
cat > scripts/example.py << 'EOF'
#!/usr/bin/env python3
"""Example script for the skill."""

def main():
    print("Skill is working!")

if __name__ == "__main__":
    main()
EOF

chmod +x scripts/example.py

# references/ディレクトリ（オプション）
mkdir -p references

# assets/ディレクトリ（オプション）
mkdir -p assets
```

### 3. スキルを検証

```bash
# SKILL.mdの検証
cat SKILL.md | grep -q "^---" && echo "✓ Frontmatter found" || echo "✗ Missing frontmatter"
cat SKILL.md | grep -q "description:" && echo "✓ Description found" || echo "✗ Missing description"
cat SKILL.md | grep -q "allowed-tools:" && echo "✓ Allowed-tools found" || echo "✗ Missing allowed-tools"
```

### 4. ローカルにインストール

```bash
# ~/.claude/commands/ にシンボリックリンク
ln -s ~/.claude/skills/my-new-skill/SKILL.md ~/.claude/commands/my-new-skill.md

# 確認
ls -la ~/.claude/commands/ | grep my-new-skill
```

### 5. スキルをテスト

Claude Codeで以下を実行:
```
/my-new-skill
```

## Slack連携（Rube使用）

### Rubeのセットアップ

Rubeは、Slackとのインテグレーションを提供する（セットアップ詳細は省略）。

### Slackへの通知

```bash
# Rube経由でSlackに投稿（概念例）
# 実際のコマンドはRubeの設定に依存

# 投稿内容
SKILL_NAME="my-new-skill"
SKILL_DESC="Brief description of the skill"
SLACK_CHANNEL="#claude-skills"

# メッセージ作成
MESSAGE="🚀 New Claude Skill Available: *${SKILL_NAME}*\n\n${SKILL_DESC}\n\nInstall: \`ln -s ~/.claude/skills/${SKILL_NAME}/SKILL.md ~/.claude/commands/${SKILL_NAME}.md\`"

# Slackに投稿
# rube post --channel "${SLACK_CHANNEL}" --message "${MESSAGE}"
```

## 自動化スクリプト

### skill-share.sh

```bash
#!/usr/bin/env bash
# skill-share.sh - Automate skill creation and sharing

set -e

SKILL_NAME="$1"
SKILL_DESC="$2"
SLACK_CHANNEL="${3:-#claude-skills}"

if [ -z "$SKILL_NAME" ] || [ -z "$SKILL_DESC" ]; then
    echo "Usage: $0 <skill-name> <description> [slack-channel]"
    exit 1
fi

SKILL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"

# 1. ディレクトリ作成
mkdir -p "${SKILL_DIR}"/{scripts,references,assets}

# 2. SKILL.md作成
cat > "${SKILL_DIR}/SKILL.md" << EOF
---
description: "${SKILL_DESC}"
allowed-tools:
  - Read
  - Write
---

# ${SKILL_NAME}

## 概要
${SKILL_DESC}

## 使い方
1. Step 1
2. Step 2

## 依存関係
- Dependency 1
EOF

# 3. シンボリックリンク作成
ln -sf "${SKILL_DIR}/SKILL.md" "${HOME}/.claude/commands/${SKILL_NAME}.md"

# 4. 検証
echo "✓ Skill directory created: ${SKILL_DIR}"
echo "✓ SKILL.md created"
echo "✓ Symlink created: ~/.claude/commands/${SKILL_NAME}.md"

# 5. Slack通知（Rube設定が必要）
# if command -v rube &> /dev/null; then
#     rube post --channel "${SLACK_CHANNEL}" --message "🚀 New skill: *${SKILL_NAME}*"
# fi

echo ""
echo "✅ Skill '${SKILL_NAME}' created successfully!"
echo "   Test with: /claude-code and run /${SKILL_NAME}"
```

使い方:
```bash
chmod +x skill-share.sh
./skill-share.sh my-skill "Description of my skill" "#team-channel"
```

## スキルのパッケージ化

### tar.gz形式

```bash
cd ~/.claude/skills
tar -czf my-skill.tar.gz my-skill/
```

### 配布

```bash
# チームメンバーに送信
# 受信者側:
cd ~/.claude/skills
tar -xzf my-skill.tar.gz
ln -s ~/.claude/skills/my-skill/SKILL.md ~/.claude/commands/my-skill.md
```

## スキルレジストリ（チーム内）

### GitHub Repository

```bash
# チームスキルリポジトリ
cd ~/.claude/skills
git init
git remote add origin https://github.com/your-org/claude-skills

# 新しいスキルを追加
git add my-new-skill/
git commit -m "Add my-new-skill"
git push origin main
```

### チームメンバーのインストール

```bash
# リポジトリをクローン
cd ~/.claude/skills
git clone https://github.com/your-org/claude-skills.git

# 全スキルをインストール
cd claude-skills
for skill in */SKILL.md; do
    skill_name=$(basename $(dirname $skill))
    ln -s "$(pwd)/${skill}" "${HOME}/.claude/commands/${skill_name}.md"
done
```

## ベストプラクティス

### 1. 命名規則

- kebab-case: `my-skill-name`
- 簡潔で説明的
- 既存スキルと重複しない

### 2. ドキュメント

- READMEを含める
- 使用例を豊富に
- トラブルシューティングセクション

### 3. バージョン管理

```markdown
## Changelog

### v1.0.0 (2024-01-15)
- Initial release

### v1.1.0 (2024-02-01)
- Added feature X
- Fixed bug Y
```

### 4. テスト

```bash
# スキルが正しく動作するかテスト
# テストスクリプト例
tests/test_skill.sh
```

## トラブルシューティング

### スキルが認識されない
→ シンボリックリンクが正しいか確認: `ls -la ~/.claude/commands/`

### Frontmatterエラー
→ YAML構文を確認、インデントは2スペース

### Slack通知が届かない
→ Rube設定を確認、チャンネル名が正しいか確認

## 参考

- Claude Skill Creator: `/skill-creator`
- awesome-claude-skills: https://github.com/ComposioHQ/awesome-claude-skills
- Rube (Slack integration): 各組織の設定に依存
