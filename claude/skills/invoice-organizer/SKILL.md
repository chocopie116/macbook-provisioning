---
name: invoice-organizer
description: "Use this skill when you need to organize invoices and receipts for tax preparation, extract information from financial documents, or standardize file naming for accounting."
---

# Invoice Organizer

請求書・領収書を自動整理し、税務準備を効率化。

## 概要

散らかった財務書類を、クリーンで税務対応可能なファイリングシステムに変換:
1. **情報抽出**: ベンダー名、請求書番号、日付、金額、説明、支払方法を読み取り
2. **標準化命名**: 一貫した形式でファイル名を変更
3. **柔軟な整理**: ベンダー別、カテゴリ別、期間別、税区分別に分類
4. **元ファイル保持**: オリジナルファイルを保存しつつコピーを整理

## インストール

```bash
pip install pypdf pdfplumber pillow pytesseract
brew install tesseract  # OCR用
```

## 基本的な使い方

### 1. 請求書フォルダのスキャン

```bash
# 請求書が散在しているフォルダ
cd ~/Downloads/invoices

# ファイルを確認
ls -la | grep -E "\.(pdf|jpg|png|jpeg)"
```

### 2. 情報抽出

```python
import pdfplumber
import re
from datetime import datetime

def extract_invoice_info(pdf_path):
    """請求書からキー情報を抽出"""
    with pdfplumber.open(pdf_path) as pdf:
        text = ""
        for page in pdf.pages:
            text += page.extract_text()

    # パターンマッチング
    vendor = extract_vendor(text)
    invoice_number = extract_invoice_number(text)
    date = extract_date(text)
    amount = extract_amount(text)

    return {
        "vendor": vendor,
        "invoice_number": invoice_number,
        "date": date,
        "amount": amount,
        "description": extract_description(text)
    }

def extract_vendor(text):
    """ベンダー名抽出"""
    # よくあるパターン
    patterns = [
        r"From:\s*(.+)",
        r"Vendor:\s*(.+)",
        r"^(.+?)\n",  # 最初の行
    ]
    for pattern in patterns:
        match = re.search(pattern, text, re.MULTILINE)
        if match:
            return match.group(1).strip()
    return "Unknown"

def extract_invoice_number(text):
    """請求書番号抽出"""
    pattern = r"Invoice\s*#?\s*:?\s*(\S+)"
    match = re.search(pattern, text, re.IGNORECASE)
    return match.group(1) if match else "NoNumber"

def extract_date(text):
    """日付抽出"""
    patterns = [
        r"Date:\s*(\d{4}-\d{2}-\d{2})",
        r"(\d{2}/\d{2}/\d{4})",
        r"(\d{4}/\d{2}/\d{2})",
    ]
    for pattern in patterns:
        match = re.search(pattern, text)
        if match:
            date_str = match.group(1)
            # 日付フォーマットを標準化
            try:
                if "/" in date_str:
                    if date_str.count("/") == 2:
                        parts = date_str.split("/")
                        if len(parts[0]) == 4:  # YYYY/MM/DD
                            return date_str.replace("/", "-")
                        else:  # MM/DD/YYYY
                            return f"{parts[2]}-{parts[0]}-{parts[1]}"
                return date_str
            except:
                pass
    return datetime.now().strftime("%Y-%m-%d")

def extract_amount(text):
    """金額抽出"""
    pattern = r"Total:?\s*\$?([\d,]+\.?\d*)"
    match = re.search(pattern, text, re.IGNORECASE)
    if match:
        return match.group(1).replace(",", "")
    return "0"

def extract_description(text):
    """サービス説明抽出"""
    # 例: "Description: Web hosting"
    pattern = r"Description:\s*(.+)"
    match = re.search(pattern, text, re.IGNORECASE)
    return match.group(1).strip() if match else "Service"
```

### 3. 標準化ファイル名生成

命名規則: `YYYY-MM-DD Vendor - Invoice - ProductOrService.ext`

```python
def generate_standard_filename(info, original_ext):
    """標準化ファイル名を生成"""
    date = info["date"]
    vendor = sanitize_filename(info["vendor"])
    invoice = info["invoice_number"]
    description = sanitize_filename(info["description"])

    filename = f"{date} {vendor} - Invoice - {description}.{original_ext}"
    return filename

def sanitize_filename(name):
    """ファイル名から無効文字を削除"""
    # 無効文字を置換
    invalid_chars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|']
    for char in invalid_chars:
        name = name.replace(char, '')
    return name.strip()
```

### 4. 整理実行

```python
import shutil
from pathlib import Path

def organize_invoices(source_dir, dest_dir, strategy="by-vendor"):
    """請求書を整理"""
    source_path = Path(source_dir)
    dest_path = Path(dest_dir)
    dest_path.mkdir(exist_ok=True)

    # PDF/画像ファイルを検索
    invoice_files = []
    for ext in ['*.pdf', '*.jpg', '*.png', '*.jpeg']:
        invoice_files.extend(source_path.glob(ext))

    print(f"Found {len(invoice_files)} invoice files")

    for invoice_file in invoice_files:
        try:
            # 情報抽出
            info = extract_invoice_info(invoice_file)

            # 新しいファイル名
            new_filename = generate_standard_filename(
                info,
                invoice_file.suffix[1:]
            )

            # 整理戦略に応じてフォルダ決定
            subfolder = get_subfolder(info, strategy)
            target_dir = dest_path / subfolder
            target_dir.mkdir(parents=True, exist_ok=True)

            # コピー（元ファイルは保持）
            target_path = target_dir / new_filename
            shutil.copy2(invoice_file, target_path)
            print(f"✓ Organized: {new_filename}")

        except Exception as e:
            print(f"✗ Error processing {invoice_file.name}: {e}")

def get_subfolder(info, strategy):
    """整理戦略に基づきサブフォルダを決定"""
    if strategy == "by-vendor":
        return info["vendor"]

    elif strategy == "by-category":
        # カテゴリ推測（説明から）
        desc = info["description"].lower()
        if "software" in desc or "saas" in desc:
            return "Software"
        elif "office" in desc or "supplies" in desc:
            return "Office Supplies"
        elif "travel" in desc or "hotel" in desc:
            return "Travel"
        else:
            return "Other"

    elif strategy == "by-year":
        year = info["date"][:4]
        return year

    elif strategy == "by-quarter":
        year = info["date"][:4]
        month = int(info["date"][5:7])
        quarter = (month - 1) // 3 + 1
        return f"{year}/Q{quarter}"

    else:
        return "Organized"

# 実行
organize_invoices(
    source_dir="~/Downloads/invoices",
    dest_dir="~/Documents/Invoices_Organized",
    strategy="by-vendor"
)
```

## 整理パターン

### By Vendor（ベンダー別）

```
Invoices_Organized/
├── Adobe/
│   ├── 2024-01-15 Adobe - Invoice - Creative Cloud.pdf
│   └── 2024-02-15 Adobe - Invoice - Creative Cloud.pdf
├── AWS/
│   ├── 2024-01-01 AWS - Invoice - Cloud Services.pdf
│   └── 2024-02-01 AWS - Invoice - Cloud Services.pdf
└── GitHub/
    └── 2024-01-10 GitHub - Invoice - Team Plan.pdf
```

### By Category（カテゴリ別）

```
Invoices_Organized/
├── Software/
│   ├── 2024-01-15 Adobe - Invoice - Creative Cloud.pdf
│   └── 2024-01-10 GitHub - Invoice - Team Plan.pdf
├── Office/
│   └── 2024-01-20 Staples - Invoice - Office Supplies.pdf
└── Travel/
    └── 2024-02-05 Delta - Invoice - Flight.pdf
```

### By Year + Category（年・カテゴリ別）

```
Invoices_Organized/
├── 2024/
│   ├── Software/
│   ├── Office/
│   └── Travel/
└── 2023/
    ├── Software/
    └── Office/
```

### By Tax Category（税区分別）

```
Invoices_Organized/
├── Deductible/
│   ├── Business_Software/
│   ├── Business_Travel/
│   └── Office_Expenses/
└── Non-Deductible/
    └── Personal/
```

## CSV出力（会計ソフト用）

```python
import csv

def generate_csv_summary(organized_dir, output_csv):
    """整理した請求書のCSVサマリーを生成"""
    invoices = []

    for pdf_file in Path(organized_dir).rglob("*.pdf"):
        info = extract_invoice_info(pdf_file)
        invoices.append({
            "Date": info["date"],
            "Vendor": info["vendor"],
            "Invoice Number": info["invoice_number"],
            "Amount": info["amount"],
            "Description": info["description"],
            "Category": pdf_file.parent.name,
            "File Path": str(pdf_file)
        })

    # CSV書き出し
    with open(output_csv, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=invoices[0].keys())
        writer.writeheader()
        writer.writerows(invoices)

    print(f"✓ CSV summary generated: {output_csv}")

# 実行
generate_csv_summary(
    "~/Documents/Invoices_Organized",
    "~/Documents/invoices_2024.csv"
)
```

## 画像（領収書）の処理

```python
from PIL import Image
import pytesseract

def extract_from_image(image_path):
    """画像からOCRでテキスト抽出"""
    img = Image.open(image_path)
    text = pytesseract.image_to_string(img, lang="jpn+eng")

    # 同じ抽出ロジックを適用
    # extract_vendor(text)等
    return text
```

## 自動化スクリプト

```bash
#!/usr/bin/env bash
# organize_invoices.sh - 請求書の自動整理

SOURCE_DIR="${1:-$HOME/Downloads}"
DEST_DIR="${2:-$HOME/Documents/Invoices_Organized}"
STRATEGY="${3:-by-vendor}"

echo "Organizing invoices from ${SOURCE_DIR} to ${DEST_DIR}"
echo "Strategy: ${STRATEGY}"

python3 << EOF
from invoice_organizer import organize_invoices

organize_invoices(
    source_dir="${SOURCE_DIR}",
    dest_dir="${DEST_DIR}",
    strategy="${STRATEGY}"
)
EOF

echo "✅ Organization complete!"
```

実行:
```bash
chmod +x organize_invoices.sh
./organize_invoices.sh ~/Downloads ~/Documents/Invoices_Organized by-category
```

## 重複検出

```python
import hashlib

def calculate_hash(file_path):
    """ファイルのハッシュ値計算"""
    hasher = hashlib.md5()
    with open(file_path, 'rb') as f:
        hasher.update(f.read())
    return hasher.hexdigest()

def find_duplicates(directory):
    """重複ファイルを検出"""
    hashes = {}
    duplicates = []

    for file_path in Path(directory).rglob("*.pdf"):
        file_hash = calculate_hash(file_path)
        if file_hash in hashes:
            duplicates.append((hashes[file_hash], file_path))
        else:
            hashes[file_hash] = file_path

    return duplicates
```

## ベストプラクティス

### 1. バックアップ

```bash
# 整理前にバックアップ
cp -r ~/Downloads/invoices ~/Downloads/invoices_backup
```

### 2. ドライラン

```python
# 実際のコピー前にプレビュー
def organize_invoices(source_dir, dest_dir, strategy, dry_run=True):
    # ...
    if dry_run:
        print(f"Would copy to: {target_path}")
    else:
        shutil.copy2(invoice_file, target_path)
```

### 3. 命名規則の一貫性

- 日付: YYYY-MM-DD（ソート可能）
- ベンダー: 正式名称
- 説明: 簡潔で明確

### 4. 定期実行

```bash
# crontabで毎週日曜日に実行
0 0 * * 0 /path/to/organize_invoices.sh
```

## トラブルシューティング

### OCRが失敗する
→ 画像の解像度を上げる、`tesseract`の言語パック確認

### ベンダー名が抽出できない
→ パターンを追加、手動マッピングテーブル作成

### ファイル名が長すぎる
→ 説明を短縮、最大文字数制限

### 日付が正しく解析されない
→ 日付フォーマットパターンを追加

## 参考

- pdfplumber: https://github.com/jsvine/pdfplumber
- pytesseract: https://github.com/madmaze/pytesseract
- Pillow: https://pillow.readthedocs.io/
