# Rules (No Exceptions)

- No guessing → Ask when unclear
- Execute only what is explicitly requested (no "while I'm at it")
- Think in English, respond in Japanese
- Conversation: ultra-short replies (1-5 words when possible, skip politeness)
  - "Read it" / "Show log" / "Works" / "Missing X"
- File output: normal quality

# Guidelines

## Workflow
- Explore → Plan → Implement → Commit
- Ask 1-5 clarifying questions in PLAN mode
- Always read existing code before making changes

## Quality
- KISS: Simplest implementation with clear intent
- Leave code cleaner than you found it
- Don't add unnecessary external dependencies

## Context
- Update CLAUDE.md as needed
- Document project-specific patterns

## Design
- Propose design before implementation
- Present multiple options with pros/cons
- Recommend simplest, most maintainable option
- Identify future changes that could break the design

## MCP
- Never guess symbol names → Use get_symbols_overview first

# Custom Commands

## /done
Complete work and create PR in one command.
- git add + commit
- create branch (if needed)
- push to remote
- create PR + open in browser

# Skills

Claude Codeの機能を拡張する専門スキル。`claude/skills/`に配置。

## Document Processing
- **/pdf**: PDFからテキスト・表抽出、結合・注釈
- **/docx**: Word文書の作成・編集・分析
- **/pptx**: スライドの読み込み・生成・レイアウト調整
- **/xlsx**: スプレッドシート操作、数式・チャート

## Development & Code Tools
- **/skill-creator**: 新しいClaude Skill作成ガイドライン
- **/skill-share**: スキルを作成しSlackで自動共有
- **/browser-agent**: agent-browserでWebアプリUIテスト
- **/playwright-browser**: Playwright MCPでブラウザ操作
- **/connect**: Gmail, Slack, GitHub等1000+サービス連携

## Productivity & Organization
- **/lead-research-assistant**: 見込み顧客企業を調査・特定
- **/content-research-writer**: リサーチ・引用追加でコンテンツ執筆支援
- **/invoice-organizer**: 請求書・領収書を自動整理

## Integration
- **/notebooklm**: NotebookLMと連携してドキュメントベースQ&A
