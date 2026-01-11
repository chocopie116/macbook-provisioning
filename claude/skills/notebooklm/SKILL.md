---
name: notebooklm
description: "Use this skill when you need to query Google NotebookLM for source-grounded answers based on your uploaded documents, integrating NotebookLM's document Q&A with Claude Code."
---

# NotebookLM Integration

NotebookLMと連携してドキュメントベースのQ&Aを実行。

## 概要

Google NotebookLMとClaude Codeを統合:
- NotebookLMにアップロードされたドキュメントに基づく回答取得
- ソースに基づいた（source-grounded）情報のみ
- ブラウザ自動化経由でNotebookLMにクエリ送信

## 重要な制約

- **ローカルClaude Codeのみ**: Web UIのサンドボックス環境では動作不可
- **ステートレス**: 各クエリは独立（チャット履歴なし）
- **手動ドキュメントアップロード**: 事前にNotebookLMにドキュメントをアップロード必要
- **公開共有必須**: ノートブックは公開共有設定が必要

## アーキテクチャ

### 実装方式

1. **Python + Patchright** (ブラウザ自動化ライブラリ)
2. **Google Chrome** (Chromiumではなく、信頼性と検出回避のため)
3. **ローカルスキルディレクトリ**: `~/.claude/skills/notebooklm/`
4. **隔離された仮想環境**: 依存関係を分離

### ディレクトリ構造

```
~/.claude/skills/notebooklm/
├── SKILL.md              # Claudeへの指示
├── scripts/
│   ├── setup.py          # 初回セットアップ
│   ├── query.py          # NotebookLMクエリ実行
│   └── auth.py           # Google認証
├── .venv/                # Python仮想環境
├── data/
│   ├── session.json      # 認証セッション
│   └── notebooks.json    # ノートブックメタデータ
└── requirements.txt
```

## セットアップ

### 1. 依存関係のインストール

```bash
# スキルディレクトリ作成
mkdir -p ~/.claude/skills/notebooklm/{scripts,data}
cd ~/.claude/skills/notebooklm

# 仮想環境作成
python3 -m venv .venv
source .venv/bin/activate

# requirements.txt作成
cat > requirements.txt << 'EOF'
patchright==0.0.2
python-dotenv==1.0.0
EOF

# インストール
pip install -r requirements.txt

# Chromeがインストール済みか確認
which google-chrome-stable || which google-chrome
```

macOSの場合:
```bash
# Google Chrome インストール（未インストールの場合）
brew install --cask google-chrome
```

### 2. Google認証の設定

```bash
# 認証スクリプト作成
cat > scripts/auth.py << 'PYEOF'
#!/usr/bin/env python3
"""Google認証とセッション保存"""

from patchright.sync_api import sync_playwright
import json
from pathlib import Path

def authenticate():
    """Googleアカウント認証"""
    data_dir = Path(__file__).parent.parent / "data"
    data_dir.mkdir(exist_ok=True)
    session_file = data_dir / "session.json"

    with sync_playwright() as p:
        # Chrome起動
        browser = p.chromium.launch(
            headless=False,  # 手動認証のため表示
            channel="chrome"
        )
        context = browser.new_context()
        page = context.new_page()

        # NotebookLMにナビゲート
        page.goto("https://notebooklm.google.com/")

        print("Please log in to your Google account...")
        print("Press Enter after you've logged in successfully.")
        input()

        # セッション保存
        storage = context.storage_state()
        with open(session_file, "w") as f:
            json.dump(storage, f)

        print(f"✓ Session saved to {session_file}")
        browser.close()

if __name__ == "__main__":
    authenticate()
PYEOF

chmod +x scripts/auth.py

# 認証実行
source .venv/bin/activate
python scripts/auth.py
```

### 3. NotebookLMノートブックの準備

1. https://notebooklm.google.com/ にアクセス
2. 新しいノートブックを作成
3. ドキュメントをアップロード（PDF, DOCX, TXT等）
4. ノートブックを**公開共有**:
   - 右上の「Share」をクリック
   - 「Anyone with the link」に設定
   - リンクをコピー

### 4. クエリスクリプトの作成

```bash
cat > scripts/query.py << 'PYEOF'
#!/usr/bin/env python3
"""NotebookLMにクエリを送信"""

import sys
import json
from pathlib import Path
from patchright.sync_api import sync_playwright

def query_notebooklm(notebook_url, question):
    """NotebookLMにクエリを送信して回答を取得"""
    data_dir = Path(__file__).parent.parent / "data"
    session_file = data_dir / "session.json"

    if not session_file.exists():
        print("Error: Session not found. Run 'python scripts/auth.py' first.")
        sys.exit(1)

    with open(session_file) as f:
        storage_state = json.load(f)

    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=True,
            channel="chrome"
        )
        context = browser.new_context(storage_state=storage_state)
        page = context.new_page()

        # NotebookLMノートブックにアクセス
        page.goto(notebook_url)
        page.wait_for_load_state("networkidle")

        # チャット入力フィールドを見つける
        # (セレクタはNotebookLMのUIに依存、変更される可能性あり)
        chat_input = page.locator('textarea[placeholder*="Ask"]').first
        chat_input.fill(question)
        chat_input.press("Enter")

        # 回答を待つ
        page.wait_for_timeout(5000)  # 5秒待機（調整必要）

        # 最新の回答を取得
        # (セレクタは要調整)
        response = page.locator('.response-text').last.inner_text()

        browser.close()
        return response

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python query.py <notebook_url> <question>")
        sys.exit(1)

    notebook_url = sys.argv[1]
    question = " ".join(sys.argv[2:])

    answer = query_notebooklm(notebook_url, question)
    print("\n=== Answer ===")
    print(answer)
PYEOF

chmod +x scripts/query.py
```

**注意**: NotebookLMのUIセレクタは変更される可能性があります。実際のHTML構造に合わせて調整が必要です。

### 5. ノートブックライブラリの管理

```bash
cat > scripts/manage_notebooks.py << 'PYEOF'
#!/usr/bin/env python3
"""ノートブックのメタデータ管理"""

import json
from pathlib import Path

def add_notebook(name, url, tags=None):
    """ノートブックをライブラリに追加"""
    data_dir = Path(__file__).parent.parent / "data"
    notebooks_file = data_dir / "notebooks.json"

    # 既存データ読み込み
    if notebooks_file.exists():
        with open(notebooks_file) as f:
            notebooks = json.load(f)
    else:
        notebooks = []

    # 新しいノートブック追加
    notebooks.append({
        "name": name,
        "url": url,
        "tags": tags or []
    })

    # 保存
    with open(notebooks_file, "w") as f:
        json.dump(notebooks, f, indent=2)

    print(f"✓ Added notebook: {name}")

def list_notebooks():
    """ノートブックを一覧表示"""
    data_dir = Path(__file__).parent.parent / "data"
    notebooks_file = data_dir / "notebooks.json"

    if not notebooks_file.exists():
        print("No notebooks found.")
        return

    with open(notebooks_file) as f:
        notebooks = json.load(f)

    print("\n=== NotebookLM Library ===")
    for i, nb in enumerate(notebooks, 1):
        print(f"{i}. {nb['name']}")
        print(f"   URL: {nb['url']}")
        print(f"   Tags: {', '.join(nb['tags'])}\n")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python manage_notebooks.py add <name> <url> [tags...]")
        print("  python manage_notebooks.py list")
        sys.exit(1)

    command = sys.argv[1]
    if command == "add":
        name = sys.argv[2]
        url = sys.argv[3]
        tags = sys.argv[4:] if len(sys.argv) > 4 else []
        add_notebook(name, url, tags)
    elif command == "list":
        list_notebooks()
PYEOF

chmod +x scripts/manage_notebooks.py
```

## 使い方

### 1. 初回認証

```bash
cd ~/.claude/skills/notebooklm
source .venv/bin/activate
python scripts/auth.py
# ブラウザでGoogleにログイン → Enterを押す
```

### 2. ノートブックを登録

```bash
python scripts/manage_notebooks.py add \
  "Product Docs" \
  "https://notebooklm.google.com/notebook/abc123" \
  "documentation" "product"

# 一覧確認
python scripts/manage_notebooks.py list
```

### 3. クエリ実行

```bash
python scripts/query.py \
  "https://notebooklm.google.com/notebook/abc123" \
  "What are the main features of the product?"
```

### 4. Claude Code経由で使用

Claude Codeで:
```
ノートブック "Product Docs" に対して質問:
"製品の主な機能は何ですか？"
```

Claude Codeは自動的にスクリプトを実行します。

## 高度な使い方

### 複数ノートブックの横断検索

```python
#!/usr/bin/env python3
"""複数ノートブックを検索"""

import json
from pathlib import Path
from query import query_notebooklm

def search_all_notebooks(question):
    """すべてのノートブックで検索"""
    data_dir = Path(__file__).parent.parent / "data"
    notebooks_file = data_dir / "notebooks.json"

    with open(notebooks_file) as f:
        notebooks = json.load(f)

    results = []
    for nb in notebooks:
        print(f"Querying: {nb['name']}...")
        try:
            answer = query_notebooklm(nb['url'], question)
            results.append({
                "notebook": nb['name'],
                "answer": answer
            })
        except Exception as e:
            print(f"Error querying {nb['name']}: {e}")

    return results

if __name__ == "__main__":
    import sys
    question = " ".join(sys.argv[1:])
    results = search_all_notebooks(question)

    print("\n=== Results ===")
    for r in results:
        print(f"\n## {r['notebook']}")
        print(r['answer'])
```

### タグベースのフィルタリング

```python
def query_by_tag(tag, question):
    """特定タグのノートブックのみクエリ"""
    with open("data/notebooks.json") as f:
        notebooks = json.load(f)

    filtered = [nb for nb in notebooks if tag in nb.get("tags", [])]

    for nb in filtered:
        answer = query_notebooklm(nb['url'], question)
        print(f"[{nb['name']}]: {answer}")
```

## トラブルシューティング

### 認証エラー
→ `python scripts/auth.py` を再実行
→ セッションファイル `data/session.json` を削除して再認証

### セレクタが見つからない
→ NotebookLMのUIが変更された可能性
→ `query.py` のセレクタを更新:
```python
# ブラウザDevToolsで正しいセレクタを確認
page.locator('新しいセレクタ').first
```

### タイムアウトエラー
→ 待機時間を延長:
```python
page.wait_for_timeout(10000)  # 10秒
```

### Chromeが見つからない
→ Google Chromeがインストールされているか確認:
```bash
brew install --cask google-chrome
```

### ノートブックにアクセスできない
→ ノートブックが**公開共有**されているか確認
→ URLが正しいか確認

## セキュリティ考慮事項

1. **セッションファイルの保護**:
```bash
chmod 600 data/session.json
```

2. **公開共有のリスク**:
   - 機密情報を含むノートブックは使用しない
   - または、アクセス制限付き共有を検討

3. **定期的な再認証**:
   - セッションは期限切れになる可能性あり
   - 定期的に `auth.py` を実行

## ベストプラクティス

1. **ノートブックの整理**: タグを活用して分類
2. **具体的な質問**: NotebookLMは具体的な質問に対してより良い回答を返す
3. **ソース確認**: 回答にはソースの引用が含まれることを確認
4. **定期更新**: ドキュメントを更新したらNotebookLMでも更新

## 代替実装: MCP Server版

より永続的なセッション管理が必要な場合、MCP Serverバージョンを検討:
- https://github.com/PleasePrompto/notebooklm-mcp

利点:
- 永続的なチャット履歴
- より高度な統合

欠点:
- セットアップが複雑

## 参考

- NotebookLM: https://notebooklm.google.com/
- Patchright: https://github.com/Kaliiiiiiiiii-Vinyzu/patchright
- NotebookLM MCP Server: https://github.com/PleasePrompto/notebooklm-mcp
