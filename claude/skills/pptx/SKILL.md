---
name: pptx
description: "Use this skill when you need to create, read, or modify PowerPoint presentations (.pptx), generate slides programmatically, or work with templates and layouts."
---

# PPTX Creation, Editing, and Analysis

PowerPointプレゼンテーション（.pptx）の読み込み・生成・レイアウト調整。

## 依存ツール

- **python-pptx**: PowerPoint操作ライブラリ
- **pandoc**: PPTXからMarkdown変換
- **LibreOffice**: PPTX → PDF/画像変換
- **Playwright/Sharp**: HTMLからPPTX生成（高度な用途）

## インストール

```bash
brew install pandoc
brew install --cask libreoffice
pip install python-pptx
npm install -g pptxgenjs  # オプション
```

## 基本操作

### 新規プレゼンテーション作成

```python
from pptx import Presentation
from pptx.util import Inches, Pt

prs = Presentation()

# タイトルスライド
title_slide_layout = prs.slide_layouts[0]
slide = prs.slides.add_slide(title_slide_layout)
title = slide.shapes.title
subtitle = slide.placeholders[1]
title.text = "Presentation Title"
subtitle.text = "Subtitle"

# コンテンツスライド
bullet_slide_layout = prs.slide_layouts[1]
slide = prs.slides.add_slide(bullet_slide_layout)
shapes = slide.shapes
title_shape = shapes.title
body_shape = shapes.placeholders[1]

title_shape.text = "Slide Title"
tf = body_shape.text_frame
tf.text = "First bullet point"

# 追加の箇条書き
p = tf.add_paragraph()
p.text = "Second bullet point"
p.level = 1  # インデント

prs.save("presentation.pptx")
```

### 既存PPTXの読み込み

```python
from pptx import Presentation

prs = Presentation("existing.pptx")

# 全スライドのテキスト
for i, slide in enumerate(prs.slides):
    print(f"--- Slide {i+1} ---")
    for shape in slide.shapes:
        if hasattr(shape, "text"):
            print(shape.text)
```

### 画像追加

```python
from pptx import Presentation
from pptx.util import Inches

prs = Presentation()
blank_slide_layout = prs.slide_layouts[6]
slide = prs.slides.add_slide(blank_slide_layout)

# 画像配置
left = Inches(1)
top = Inches(1)
width = Inches(5)
slide.shapes.add_picture("image.png", left, top, width=width)

prs.save("with_image.pptx")
```

### 表の追加

```python
from pptx import Presentation
from pptx.util import Inches

prs = Presentation()
blank_slide_layout = prs.slide_layouts[6]
slide = prs.slides.add_slide(blank_slide_layout)

# 表追加（2行3列）
rows, cols = 2, 3
left = Inches(1)
top = Inches(2)
width = Inches(8)
height = Inches(2)

table = slide.shapes.add_table(rows, cols, left, top, width, height).table

# ヘッダー
table.cell(0, 0).text = "Column 1"
table.cell(0, 1).text = "Column 2"
table.cell(0, 2).text = "Column 3"

# データ
table.cell(1, 0).text = "Value 1"
table.cell(1, 1).text = "Value 2"
table.cell(1, 2).text = "Value 3"

prs.save("with_table.pptx")
```

### グラフ追加

```python
from pptx import Presentation
from pptx.chart.data import CategoryChartData
from pptx.enum.chart import XL_CHART_TYPE
from pptx.util import Inches

prs = Presentation()
slide = prs.slides.add_slide(prs.slide_layouts[6])

# グラフデータ
chart_data = CategoryChartData()
chart_data.categories = ["Q1", "Q2", "Q3", "Q4"]
chart_data.add_series("Series 1", (10, 20, 30, 40))

# グラフ追加
x, y, cx, cy = Inches(2), Inches(2), Inches(6), Inches(4)
chart = slide.shapes.add_chart(
    XL_CHART_TYPE.COLUMN_CLUSTERED, x, y, cx, cy, chart_data
).chart

chart.has_legend = True
chart.chart_title.text_frame.text = "Sales by Quarter"

prs.save("with_chart.pptx")
```

## 高度な操作

### スライドマスター・レイアウト確認

```python
from pptx import Presentation

prs = Presentation("template.pptx")

# 使用可能なレイアウト
for i, layout in enumerate(prs.slide_layouts):
    print(f"Layout {i}: {layout.name}")
```

### テキストのスタイル設定

```python
from pptx import Presentation
from pptx.util import Pt
from pptx.dml.color import RGBColor

prs = Presentation()
slide = prs.slides.add_slide(prs.slide_layouts[6])
txBox = slide.shapes.add_textbox(Inches(1), Inches(1), Inches(5), Inches(1))
tf = txBox.text_frame

p = tf.add_paragraph()
p.text = "Styled Text"
p.font.size = Pt(24)
p.font.bold = True
p.font.color.rgb = RGBColor(255, 0, 0)

prs.save("styled_text.pptx")
```

### PPTXをPDFに変換

```bash
libreoffice --headless --convert-to pdf presentation.pptx --outdir .
```

### PPTXをサムネイル画像に変換

```bash
# PPTX → PDF → 画像
libreoffice --headless --convert-to pdf presentation.pptx --outdir .
pdftoppm -jpeg -r 150 presentation.pdf slides
# → slides-1.jpg, slides-2.jpg, ...
```

### PPTXからテキスト抽出

```bash
pandoc presentation.pptx -o output.txt
```

### スライドの複製

```python
from pptx import Presentation
import copy

prs = Presentation("input.pptx")

# 最初のスライドを複製
slide_to_copy = prs.slides[0]

# 新しいスライドとして追加
# 注: python-pptxにはslide複製の直接的なメソッドがないため、
# xml操作が必要（複雑）。LibreOfficeやVBAを推奨
```

### スライドの並び替え

```python
from pptx import Presentation

prs = Presentation("input.pptx")

# スライドの順序変更（0番目と1番目を入れ替え）
slides = list(prs.slides._sldIdLst)
slides[0], slides[1] = slides[1], slides[0]

prs.save("reordered.pptx")
```

## デザインのベストプラクティス

### カラーパレット

推奨カラーパレット例:
- **プロフェッショナル**: ネイビー (#1A237E) + ゴールド (#FBC02D)
- **モダン**: ブラック (#000000) + オレンジ (#FF5722)
- **ナチュラル**: グリーン (#4CAF50) + ベージュ (#D7CCC8)

### フォント

- **タイトル**: 32-44pt、太字
- **本文**: 18-24pt、標準
- **注釈**: 12-16pt

### レイアウト

- 1スライド1メッセージ
- 余白を十分に確保
- 画像は高解像度（最低150dpi）

## トラブルシューティング

### 日本語フォントが反映されない
→ システムフォントを確認、`run.font.name`に正確なフォント名

### 画像が圧縮される
→ PowerPoint設定で画像圧縮を無効化

### グラフが表示されない
→ python-pptxのバージョン確認、chart_dataの形式確認

### スライドマスターが適用されない
→ `prs.slide_layouts[X]`で適切なレイアウトを選択

## 参考

- python-pptx: https://python-pptx.readthedocs.io/
- pptxgenjs: https://gitbrent.github.io/PptxGenJS/
- LibreOffice CLI: https://help.libreoffice.org/
