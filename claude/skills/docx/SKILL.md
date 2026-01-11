---
name: docx
description: "Use this skill when you need to create, edit, or analyze Word documents (.docx), work with tracked changes and comments, or convert DOCX to other formats."
---

# DOCX Document Management

Word文書（.docx）の作成・編集・分析・変更履歴管理。

## 依存ツール

- **pandoc**: DOCXからMarkdown/HTML等への変換
- **python-docx**: Word文書の作成・編集
- **LibreOffice**: DOCXの画像変換・CLI操作
- **defusedxml**: 安全なXML解析

## インストール

```bash
brew install pandoc
brew install --cask libreoffice
pip install python-docx defusedxml
```

## 基本操作

### DOCXからMarkdownに変換

```bash
pandoc input.docx -o output.md
```

### DOCXからテキスト抽出

```bash
pandoc input.docx -t plain -o output.txt
```

### 新規DOCX作成

```python
from docx import Document
from docx.shared import Pt, Inches

doc = Document()

# タイトル
doc.add_heading("Document Title", level=0)

# 段落
p = doc.add_paragraph("This is the first paragraph.")

# 箇条書き
doc.add_paragraph("Item 1", style="List Bullet")
doc.add_paragraph("Item 2", style="List Bullet")

# 表
table = doc.add_table(rows=3, cols=3)
table.style = "Light Grid Accent 1"
for i, row in enumerate(table.rows):
    for j, cell in enumerate(row.cells):
        cell.text = f"Row {i+1}, Col {j+1}"

# 画像
doc.add_picture("image.png", width=Inches(4))

doc.save("output.docx")
```

### 既存DOCXの読み込み

```python
from docx import Document

doc = Document("input.docx")

# 全段落のテキスト
for para in doc.paragraphs:
    print(para.text)

# 表の内容
for table in doc.tables:
    for row in table.rows:
        for cell in row.cells:
            print(cell.text, end="\t")
        print()
```

### コメント・メタデータ抽出

DOCXは実際にはZIPファイル:
```bash
# 解凍
unzip input.docx -d docx_contents

# コメント確認
cat docx_contents/word/comments.xml

# メタデータ
cat docx_contents/docProps/core.xml
```

Python経由:
```python
import zipfile
from defusedxml import ElementTree as ET

with zipfile.ZipFile("input.docx") as zf:
    # コメント
    if "word/comments.xml" in zf.namelist():
        comments_xml = zf.read("word/comments.xml")
        tree = ET.fromstring(comments_xml)
        # 名前空間を考慮して解析
        for comment in tree.findall(".//{*}comment"):
            print(comment.attrib, comment.text)
```

## 変更履歴（Track Changes）

### 変更履歴の有効化

```python
from docx import Document

doc = Document("input.docx")
doc.settings.track_revisions = True
doc.save("output.docx")
```

### 変更履歴の確認

```bash
# 解凍してXMLを確認
unzip input.docx -d docx_contents
cat docx_contents/word/document.xml | grep -i "ins\|del"
```

### 変更の適用/拒否

python-docxは変更履歴の高度な操作をサポートしていないため、LibreOffice CLIを使用:
```bash
# すべての変更を承認
libreoffice --headless --convert-to docx --outdir . input.docx
```

## 高度な操作

### スタイルのカスタマイズ

```python
from docx import Document
from docx.shared import Pt, RGBColor
from docx.enum.text import WD_PARAGRAPH_ALIGNMENT

doc = Document()
p = doc.add_paragraph("Custom Style Text")

# フォント設定
run = p.runs[0]
run.font.name = "Arial"
run.font.size = Pt(14)
run.font.bold = True
run.font.color.rgb = RGBColor(255, 0, 0)

# 段落設定
p.alignment = WD_PARAGRAPH_ALIGNMENT.CENTER

doc.save("styled.docx")
```

### ヘッダー・フッター

```python
from docx import Document

doc = Document()
section = doc.sections[0]

# ヘッダー
header = section.header
header_para = header.paragraphs[0]
header_para.text = "Document Header"

# フッター
footer = section.footer
footer_para = footer.paragraphs[0]
footer_para.text = "Page Footer"

doc.save("with_header_footer.docx")
```

### DOCXをPDFに変換

```bash
libreoffice --headless --convert-to pdf input.docx --outdir .
```

### DOCXを画像に変換

```bash
# DOCX → PDF → JPEG
libreoffice --headless --convert-to pdf input.docx --outdir .
pdftoppm -jpeg -r 150 input.pdf output
# → output-1.jpg, output-2.jpg, ...
```

## トラブルシューティング

### 日本語フォントが反映されない
→ システムにフォントをインストール、`run.font.name`に正確な名前を指定

### 表のレイアウトが崩れる
→ `table.autofit = False`で自動調整を無効化

### 変更履歴が表示されない
→ Word側で「変更履歴の記録」が有効か確認

### pandoc変換時に画像が消える
→ `--extract-media=./media`オプションで画像を抽出

## 参考

- python-docx: https://python-docx.readthedocs.io/
- pandoc: https://pandoc.org/
- LibreOffice CLI: https://help.libreoffice.org/latest/en-US/text/shared/guide/start_parameters.html
