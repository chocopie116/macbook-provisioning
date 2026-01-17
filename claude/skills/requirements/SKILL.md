---
name: requirements
description: ISO/IEC/IEEE 15288に基づき、ヒアリング資料から要求ドキュメント（1〜7）を順次生成します。既存ドキュメントがあれば差分更新します。
---

# Requirements - 要求ドキュメント生成スキル

## 使用方法

3つの入力モードに対応:

1. **ディレクトリ指定**: `/requirements projects/taiho-kensetsu`
   - 指定パス配下の `input/` を読み込み
   - 出力先も指定パス配下

2. **ファイル指定**: `/requirements path/to/hearing.md`
   - 指定ファイルを読み込み
   - 出力先はファイルの親ディレクトリ or 確認

3. **対話モード**: `/requirements`（引数なし）
   - AskUserQuestionで要件をヒアリング
   - 出力先はカレントディレクトリ or 確認

---

## ISO/IEC/IEEE 15288 プロセスマッピング

| ドキュメント | 15288 プロセス |
|-------------|---------------|
| 1_business_analysis.md | Business or Mission Analysis (6.4.1) |
| 2_stakeholder_requirements.md | Stakeholder Needs & Requirements Definition (6.4.2) |
| 3_system_requirements.md | System Requirements Definition (6.4.3) |
| 4_architecture.md | Architecture Definition (6.4.4) |
| 5_design.md | Design Definition (6.4.5) |
| 6_roadmap.md | Project Planning (6.3.1) |
| 7_validation_checklist.md | Verification (6.4.9) + Validation (6.4.11) |

---

## 実行手順

### Step 1: 入力判定と資料読み込み

#### 1-A: 引数あり & ディレクトリの場合
```
if $ARGUMENTS がディレクトリ:
  - $ARGUMENTS/input/ の資料を全て読み込む
  - 出力先 = $ARGUMENTS/
```

#### 1-B: 引数あり & ファイルの場合
```
if $ARGUMENTS がファイル:
  - 指定ファイルを読み込む
  - 出力先 = ファイルの親ディレクトリ（確認を取る）
```

#### 1-C: 引数なしの場合（対話モード）
```
if $ARGUMENTS が空:
  - Step 1-D の対話ヒアリングを実行
  - 出力先 = AskUserQuestionで確認
```

#### 1-D: 対話ヒアリング（対話モード用）

引数なしの場合、AskUserQuestionで以下を段階的にヒアリング:

**Q1: プロジェクト概要（必須）**
- プロジェクト名/顧客名
- 何を作りたいか（1-2文）
- 主なユーザーは誰か

**Q2: 課題と目標（必須）**
- 現状の課題
- 解決したいこと
- 成功の定義

**Q3: スコープと制約（任意）**
- 必須機能（あれば）
- 除外事項（あれば）
- 予算/期間の制約

**Q4: 技術的な制約（任意）**
- 既存システムとの連携
- 指定技術/インフラ

### Step 2: 要件確認（補足質問）

資料を分析し、以下をまとめて確認する:

1. **プロジェクト概要の認識確認**
   - 顧客名、プロジェクト名
   - 背景・目的の認識

2. **ステークホルダーの優先順位**
   - 主要ステークホルダーは誰か
   - 意思決定者は誰か

3. **スコープの制約・前提条件**
   - 必須要件（Must）は何か
   - 明確な除外事項はあるか
   - 予算・期間の制約

4. **技術選定の方針**
   - 指定技術はあるか
   - 既存システムとの連携要件
   - インフラの制約

### Step 3: 1_business_analysis.md 生成

> ISO/IEC/IEEE 15288: Business or Mission Analysis (6.4.1)

**テンプレート**: `templates/1_business_analysis.md` を参照

**内容**:
- サービスフロー（As-Is / To-Be）
- ギャップ分析
- ROI試算（定量・定性）
- 問題ID（P-001〜）

**出力先**: `{output_dir}/1_business_analysis.md`

### Step 4: 2_stakeholder_requirements.md 生成

> ISO/IEC/IEEE 15288: Stakeholder Needs & Requirements Definition (6.4.2)

**テンプレート**: `templates/2_stakeholder_requirements.md` を参照

**内容**:
- ステークホルダー一覧（SH-01〜）
- ユーザーストーリー（SR-001〜）
- 優先度マトリクス
- トレードオフ・対立の整理

**出力先**: `{output_dir}/2_stakeholder_requirements.md`

### Step 5: 3_system_requirements.md 生成

> ISO/IEC/IEEE 15288: System Requirements Definition (6.4.3)

**テンプレート**: `templates/3_system_requirements.md` を参照

**内容**:
- 機能要求（FR-001〜）
- 非機能要求（NFR-001〜）
- トレーサビリティマトリクス（SR → FR）

**出力先**: `{output_dir}/3_system_requirements.md`

### Step 6: 4_architecture.md 生成

> ISO/IEC/IEEE 15288: Architecture Definition (6.4.4)

**テンプレート**: `templates/4_architecture.md` を参照

**内容**:
- システム構成図
- 技術スタック選定理由
- データモデル（ER図）
- セキュリティ設計
- NFRへの対応方針

**出力先**: `{output_dir}/4_architecture.md`

### Step 7: 5_design.md 生成

> ISO/IEC/IEEE 15288: Design Definition (6.4.5)

**テンプレート**: `templates/5_design.md` を参照

**内容**:
- 画面一覧（SCR-001〜）
- 画面遷移図
- 画面別チェックリスト
- レスポンシブ対応方針
- トレーサビリティ（SCR → FR → SR）

**出力先**: `{output_dir}/5_design.md`

### Step 8: 6_roadmap.md 生成

> ISO/IEC/IEEE 15288: Project Planning (6.3.1)

**テンプレート**: `templates/6_roadmap.md` を参照

**内容**:
- フェーズ分割戦略
- フェーズ別スコープ（FR-ID, SCR-ID）
- 工数内訳（設計/FE/BE/QA/PM）
- 費用見積
- リスク・前提条件

**出力先**: `{output_dir}/6_roadmap.md`

### Step 9: 7_validation_checklist.md 生成

> ISO/IEC/IEEE 15288: Verification (6.4.9) + Validation (6.4.11)

**テンプレート**: `templates/7_validation_checklist.md` を参照

**内容**:
- 機能テストケース（FR別）
- 画面テストケース（SCR別）
- 非機能テスト（性能、セキュリティ）
- 受入条件チェックリスト

**出力先**: `{output_dir}/7_validation_checklist.md`

### Step 10: トレーサビリティ検証

全ドキュメント生成後、以下を検証:

1. **カバレッジチェック**:
   - 全SRがFRにマッピングされているか
   - 全FRがSCRにマッピングされているか
   - 全FRがテストケースにマッピングされているか

2. **一貫性チェック**:
   - ID重複がないか
   - 参照先が存在するか

3. **結果報告**:
   - 未カバー項目があれば警告
   - トレーサビリティサマリを出力

---

## 差分更新モード

既存ドキュメントがある場合:

1. **新規input追加時**:
   - 新規情報を既存ドキュメントにマージ
   - 新しいID（SR-xxx, FR-xxx等）を採番
   - 下流ドキュメントへの影響を確認

2. **要求変更時**:
   - 変更対象のIDを特定
   - 影響範囲（下流ドキュメント）を特定
   - 変更履歴を記録

3. **削除時**:
   - IDは再利用しない（欠番扱い）
   - 参照元からのリンクを削除

---

## 注意事項

- 各ドキュメントのヘッダーに15288プロセスIDを明記すること
- ID体系（SR, FR, NFR, SCR）は一貫性を保つこと
- 日本語で記述（顧客レビュー用）
- 不明点はTBD（To Be Determined）として明示し、後で解決
