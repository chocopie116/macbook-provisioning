---
name: pdf
description: "Use this skill when you need to extract text, tables, or metadata from PDFs, merge/split documents, add annotations, or create new PDFs programmatically."
---

# PDF Processing

PDFからテキスト・表・メタデータを抽出し、結合・注釈・変換を行う。

## 依存ツール

- **pypdf**: PDF結合・分割・メタデータ抽出・ページ回転
- **pdfplumber**: テキスト・表の抽出（レイアウト保持）
- **reportlab**: PDF作成
- **pdftotext** (poppler-utils): CLI経由テキスト抽出
- **qpdf**: CLI経由で結合・分割・暗号化

## インストール

```bash
pip install pypdf pdfplumber reportlab
brew install poppler  # pdftotext, pdftoppm含む
brew install qpdf
```

## 基本操作

### テキスト抽出

**pdfplumberでレイアウト保持**:
```python
import pdfplumber

with pdfplumber.open("input.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        print(text)
```

**CLIでテキスト抽出**:
```bash
pdftotext -layout input.pdf output.txt
```

### 表の抽出

```python
import pdfplumber
import pandas as pd

with pdfplumber.open("input.pdf") as pdf:
    page = pdf.pages[0]
    table = page.extract_table()
    df = pd.DataFrame(table[1:], columns=table[0])
    df.to_excel("output.xlsx", index=False)
```

### PDF結合

**pypdfで結合**:
```python
from pypdf import PdfWriter

merger = PdfWriter()
for pdf_file in ["file1.pdf", "file2.pdf", "file3.pdf"]:
    merger.append(pdf_file)

merger.write("merged.pdf")
merger.close()
```

**qpdfで結合**:
```bash
qpdf --empty --pages file1.pdf file2.pdf -- merged.pdf
```

### PDF分割

```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader("input.pdf")
for i, page in enumerate(reader.pages):
    writer = PdfWriter()
    writer.add_page(page)
    with open(f"page_{i+1}.pdf", "wb") as f:
        writer.write(f)
```

### メタデータ抽出

```python
from pypdf import PdfReader

reader = PdfReader("input.pdf")
metadata = reader.metadata
print(f"Title: {metadata.title}")
print(f"Author: {metadata.author}")
print(f"Pages: {len(reader.pages)}")
```

### ページ回転

```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader("input.pdf")
writer = PdfWriter()

for page in reader.pages:
    page.rotate(90)  # 90度回転
    writer.add_page(page)

with open("rotated.pdf", "wb") as f:
    writer.write(f)
```

## 高度な操作

### PDFから画像抽出

```bash
# 各ページをPNG画像として抽出
pdftoppm -png input.pdf output
# → output-1.png, output-2.png, ...
```

### パスワード保護

```bash
qpdf --encrypt user-password owner-password 256 -- input.pdf encrypted.pdf
```

### OCR（スキャンPDF）

スキャンされたPDFの場合、OCRが必要:
```bash
brew install tesseract
pip install pytesseract pdf2image

# Python
from pdf2image import convert_from_path
import pytesseract

images = convert_from_path("scanned.pdf")
text = ""
for img in images:
    text += pytesseract.image_to_string(img, lang='jpn')
print(text)
```

### ウォーターマーク追加

```python
from pypdf import PdfReader, PdfWriter
from pypdf.generic import Transformation

reader = PdfReader("input.pdf")
watermark = PdfReader("watermark.pdf")
writer = PdfWriter()

for page in reader.pages:
    page.merge_page(watermark.pages[0])
    writer.add_page(page)

with open("watermarked.pdf", "wb") as f:
    writer.write(f)
```

## トラブルシューティング

### レイアウトが崩れる
→ `pdfplumber`の`extract_text(layout=True)`を試す

### 表が正しく抽出されない
→ `table_settings`パラメータを調整

### 日本語が文字化け
→ OCRの場合は`lang='jpn'`を指定、フォント埋め込み確認

## 参考

- pypdf: https://pypi.org/project/pypdf/
- pdfplumber: https://github.com/jsvine/pdfplumber
- reportlab: https://www.reportlab.com/
- poppler: https://poppler.freedesktop.org/
