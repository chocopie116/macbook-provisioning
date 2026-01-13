今日のClaude Code作業ログを取得して表示してください。

## 手順

1. `~/.claude/history.jsonl` から今日の入力履歴を取得
2. プロジェクトごとにグループ化
3. 各セッションの summary を `~/.claude/projects/` から取得
4. markdown形式で整形して表示

## 出力形式

```markdown
## Claude Code作業ログ (YYYY-MM-DD)

### プロジェクト名
- HH:MM コマンド内容
  - Summary: セッションで行った作業のサマリ
```

## 実行コマンド例

```bash
# 今日の開始時刻（JST 00:00）のエポックミリ秒
TODAY_START=$(date -v0H -v0M -v0S +%s)000

# history.jsonlから今日の入力を取得
cat ~/.claude/history.jsonl | jq -r --argjson start "$TODAY_START" '
  select(.timestamp >= $start) |
  "\(.timestamp)\t\(.project | split("/")[-1])\t\(.sessionId)\t\(.display)"
'
```

## 注意
- スラッシュコマンド（/で始まる入力）は除外してよい
- 長いコマンドは80文字程度で省略
