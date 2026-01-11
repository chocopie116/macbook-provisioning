---
name: xlsx
description: "Use this skill when you need to create, manipulate, or analyze spreadsheets (.xlsx), work with formulas and charts, or perform data transformations."
---

# XLSX Creation, Editing, and Analysis

スプレッドシート（.xlsx）の操作、数式・チャート・データ変換。

## 依存ツール

- **pandas**: データ分析・バルク操作
- **openpyxl**: 複雑な書式設定・数式操作
- **xlsxwriter**: 高速書き込み・チャート作成
- **LibreOffice**: XLSX → PDF変換・数式再計算

## インストール

```bash
brew install --cask libreoffice
pip install pandas openpyxl xlsxwriter
```

## 基本操作

### 新規XLSX作成

```python
import pandas as pd

data = {
    "Name": ["Alice", "Bob", "Charlie"],
    "Age": [25, 30, 35],
    "City": ["Tokyo", "Osaka", "Kyoto"]
}

df = pd.DataFrame(data)
df.to_excel("output.xlsx", index=False, sheet_name="Sheet1")
```

### 既存XLSXの読み込み

```python
import pandas as pd

# シート指定
df = pd.read_excel("input.xlsx", sheet_name="Sheet1")
print(df.head())

# 複数シート
all_sheets = pd.read_excel("input.xlsx", sheet_name=None)
for sheet_name, df in all_sheets.items():
    print(f"Sheet: {sheet_name}")
    print(df.head())
```

### 数式の挿入

```python
from openpyxl import Workbook

wb = Workbook()
ws = wb.active

ws["A1"] = 10
ws["A2"] = 20
ws["A3"] = "=SUM(A1:A2)"  # 数式

wb.save("with_formula.xlsx")
```

### 複数シートの操作

```python
import pandas as pd

with pd.ExcelWriter("multi_sheet.xlsx") as writer:
    df1 = pd.DataFrame({"A": [1, 2, 3]})
    df2 = pd.DataFrame({"B": [4, 5, 6]})

    df1.to_excel(writer, sheet_name="Sheet1", index=False)
    df2.to_excel(writer, sheet_name="Sheet2", index=False)
```

## 書式設定

### セルのスタイル

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment

wb = Workbook()
ws = wb.active

# テキスト
ws["A1"] = "Styled Cell"

# フォント（太字・色）
ws["A1"].font = Font(bold=True, color="FF0000", size=14)

# 背景色
ws["A1"].fill = PatternFill(start_color="FFFF00", end_color="FFFF00", fill_type="solid")

# 配置
ws["A1"].alignment = Alignment(horizontal="center", vertical="center")

wb.save("styled.xlsx")
```

### 数値フォーマット

```python
from openpyxl import Workbook

wb = Workbook()
ws = wb.active

# 通貨
ws["A1"] = 1234.56
ws["A1"].number_format = "$#,##0.00"

# パーセント
ws["A2"] = 0.85
ws["A2"].number_format = "0.0%"

# 日付
from datetime import datetime
ws["A3"] = datetime.now()
ws["A3"].number_format = "YYYY-MM-DD"

wb.save("formatted.xlsx")
```

### 条件付き書式

```python
from openpyxl import Workbook
from openpyxl.styles import PatternFill
from openpyxl.formatting.rule import CellIsRule

wb = Workbook()
ws = wb.active

ws.append([10, 20, 30, 40, 50])

# 30以上のセルを黄色に
red_fill = PatternFill(start_color="FFFF00", end_color="FFFF00", fill_type="solid")
ws.conditional_formatting.add("A1:E1", CellIsRule(operator="greaterThan", formula=["30"], fill=red_fill))

wb.save("conditional.xlsx")
```

## チャート作成

### 棒グラフ

```python
from openpyxl import Workbook
from openpyxl.chart import BarChart, Reference

wb = Workbook()
ws = wb.active

# データ
data = [
    ["Category", "Values"],
    ["A", 10],
    ["B", 20],
    ["C", 30],
]
for row in data:
    ws.append(row)

# チャート作成
chart = BarChart()
chart.title = "Bar Chart"
chart.x_axis.title = "Category"
chart.y_axis.title = "Values"

cats = Reference(ws, min_col=1, min_row=2, max_row=4)
vals = Reference(ws, min_col=2, min_row=1, max_row=4)
chart.add_data(vals, titles_from_data=True)
chart.set_categories(cats)

ws.add_chart(chart, "E5")
wb.save("bar_chart.xlsx")
```

### 折れ線グラフ

```python
from openpyxl import Workbook
from openpyxl.chart import LineChart, Reference

wb = Workbook()
ws = wb.active

ws.append(["Month", "Sales"])
ws.append(["Jan", 100])
ws.append(["Feb", 150])
ws.append(["Mar", 200])

chart = LineChart()
chart.title = "Sales Trend"
chart.x_axis.title = "Month"
chart.y_axis.title = "Sales"

data = Reference(ws, min_col=2, min_row=1, max_row=4)
cats = Reference(ws, min_col=1, min_row=2, max_row=4)
chart.add_data(data, titles_from_data=True)
chart.set_categories(cats)

ws.add_chart(chart, "D2")
wb.save("line_chart.xlsx")
```

## 高度な操作

### 数式の再計算

```bash
# LibreOffice経由で数式を再計算
libreoffice --headless --convert-to xlsx:"Calc MS Excel 2007 XML" input.xlsx --outdir .
```

### データのフィルタリング

```python
import pandas as pd

df = pd.read_excel("input.xlsx")

# 条件フィルタ
filtered = df[df["Age"] > 25]
filtered.to_excel("filtered.xlsx", index=False)
```

### ピボットテーブル（手動）

openpyxlはピボットテーブルを直接作成できないが、pandasで集計:
```python
import pandas as pd

df = pd.read_excel("input.xlsx")
pivot = df.pivot_table(values="Sales", index="Category", columns="Month", aggfunc="sum")
pivot.to_excel("pivot.xlsx")
```

### XLSXをCSVに変換

```python
import pandas as pd

df = pd.read_excel("input.xlsx")
df.to_csv("output.csv", index=False)
```

### XLSXをPDFに変換

```bash
libreoffice --headless --convert-to pdf input.xlsx --outdir .
```

### セル結合

```python
from openpyxl import Workbook

wb = Workbook()
ws = wb.active

ws.merge_cells("A1:C1")
ws["A1"] = "Merged Cell"

wb.save("merged.xlsx")
```

## ベストプラクティス

### 数式の原則

**重要**: 常にExcel数式を使用し、Pythonで計算した値をハードコードしない。
```python
# 悪い例
ws["C1"] = 30  # A1 + B1の結果をハードコード

# 良い例
ws["C1"] = "=A1+B1"  # 数式で動的計算
```

### カラーコード（財務モデル）

- **青**: ユーザー入力値
- **黒**: 計算式
- **緑**: シート間参照
- **赤**: 外部ファイル参照
- **黄色背景**: 重要な前提条件

### 数値フォーマット規則

- 年: テキスト文字列（"2024"）
- 通貨: `$#,##0`
- ゼロ: ダッシュ（`-`）表示
- パーセント: `0.0%`
- 負の値: カッコ表記（マイナス記号なし）

## トラブルシューティング

### 数式エラー
→ セル参照が正しいか確認（#REF!, #DIV/0!等）

### 日本語が文字化け
→ `encoding="utf-8"`を指定、フォントインストール確認

### チャートが表示されない
→ openpyxlバージョン確認、データ範囲確認

### 大量データで遅い
→ pandasの`chunksize`パラメータ、xlsxwriterを使用

## 参考

- pandas: https://pandas.pydata.org/
- openpyxl: https://openpyxl.readthedocs.io/
- xlsxwriter: https://xlsxwriter.readthedocs.io/
