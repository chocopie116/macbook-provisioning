---
name: lead-research-assistant
description: "Use this skill when you need to identify and qualify sales leads, research target companies based on ideal customer profiles, or develop personalized outreach strategies."
---

# Lead Research Assistant

見込み顧客企業を調査・特定し、アプローチ戦略を提案。

## 概要

営業・ビジネス開発・マーケティング担当者向けに:
1. **ビジネス理解**: プロダクト/サービス・ターゲット市場を分析
2. **ターゲット企業特定**: ICP（理想的顧客プロファイル）に基づき検索
3. **リード優先順位付け**: フィットスコアと関連性でランク付け
4. **コンタクト戦略**: 各見込み企業への個別アプローチ提案
5. **データエンリッチメント**: 意思決定者情報を収集

## 使い方

### 基本的な使い方

```
プロダクト: [製品/サービスの説明]
ターゲット: [業界、企業規模、地域、技術スタック等]

例:
"私たちはB2B SaaSのプロジェクト管理ツールを提供しています。
リモートワークを導入している50-200名規模のテック企業をターゲットにしたいです。"
```

### コードベースから分析

```
"このリポジトリのREADMEとドキュメントから製品を理解し、
適切な見込み企業を見つけてください。"
```

### 詳細なICP指定

```
製品: API管理プラットフォーム
ICP:
- 業界: フィンテック、ヘルステック
- 企業規模: 100-500名
- 地域: 日本、シンガポール
- 技術スタック: マイクロサービスアーキテクチャ
- 成長指標: 最近の資金調達、急成長中
```

## 実装ステップ

### Step 1: 製品理解

```markdown
## 製品分析

### コアバリュー
- 何を解決するか
- ユニークなセールスポイント
- 競合優位性

### ターゲット顧客
- 理想的な顧客像
- 解決する課題
- 業界/規模/地域
```

### Step 2: ICP（Ideal Customer Profile）定義

```markdown
## ICP定義

### 必須条件
- 業界: [業界名]
- 企業規模: [従業員数]
- 地域: [地域名]
- 技術: [使用技術]

### 優先条件
- 成長率: [年間成長率]
- 資金調達: [最近のラウンド]
- 課題: [抱えている課題]
```

### Step 3: ターゲット企業リサーチ

WebSearchツールを使用して:
```
- 業界ディレクトリ検索
- LinkedIn企業検索
- Crunchbase/PitchBook検索
- テック系メディア（TechCrunch等）
- 資金調達ニュース
```

### Step 4: リードスコアリング

各企業を1-10でスコアリング:
```
10: 完璧なフィット、緊急性高
8-9: 非常に良いフィット
6-7: 良いフィット
4-5: 中程度のフィット
1-3: 低いフィット
```

評価基準:
- ICP条件への適合度
- 課題の緊急性
- 予算の可能性
- 意思決定プロセス
- タイミング

### Step 5: アウトプット生成

```markdown
## リサーチ結果

### サマリー
- 総リード数: [数]
- Priority 10: [数] 社
- Priority 8-9: [数] 社
- Priority 6-7: [数] 社

---

## Priority 10 Leads

### 1. [企業名]
**Website**: [URL]
**Score**: 10/10

**Why They Fit**:
- [理由1]
- [理由2]
- [理由3]

**Target Decision Makers**:
- CEO: [名前] - [LinkedIn URL]
- CTO: [名前] - [LinkedIn URL]
- VP Engineering: [名前] - [LinkedIn URL]

**Value Proposition**:
[この企業に特化した価値提案]

**Outreach Strategy**:
1. [ステップ1]
2. [ステップ2]
3. [ステップ3]

**Conversation Starter**:
"Hi [名前], noticed [具体的な観察]. We help [業界] companies [解決する課題]. Would love to show you how we helped [類似企業] achieve [結果]."

---
```

## 実用例

### 例1: SaaS企業のリード発掘

**Input**:
```
製品: チームコラボレーションツール（Slack + Notion + Asanaの統合）
ターゲット: リモートワーク中心の50-200名のスタートアップ
```

**Output**:
```markdown
## Priority 10 Lead

### Acme Corp
**Website**: https://acme.com
**Score**: 10/10

**Why They Fit**:
- 150名規模、完全リモート
- 最近Series B調達（$20M）
- 5つの異なるコラボツールを使用中（LinkedInインタビューから）
- エンジニアリングチーム急成長中

**Target Decision Makers**:
- CEO: John Doe - linkedin.com/in/johndoe
- VP Engineering: Jane Smith - linkedin.com/in/janesmith

**Value Proposition**:
"Acme Corpは急成長中ですが、複数のツール間でのコンテキストスイッチが生産性を下げています。
私たちのツールは、すべてのコミュニケーション・タスク・ドキュメントを統合し、
平均40%の時間削減を実現します。"

**Outreach Strategy**:
1. LinkedInで接続リクエスト（共通の人脈を強調）
2. 24時間後、「リモートチームの生産性向上」について軽く言及
3. 類似企業のケーススタディを共有
4. 15分デモの提案

**Conversation Starter**:
"Hi Jane, saw Acme just raised Series B - congrats! We've helped similar-stage companies
like XYZ Corp reduce tool switching by 70%. Would love to share how. 15 min next week?"
```

### 例2: エンタープライズソリューション

**Input**:
```
製品: AIベースのサイバーセキュリティプラットフォーム
ターゲット: 金融機関、1000名以上、日本
```

**Output**:
```markdown
## Priority 9 Lead

### MegaBank Japan
**Website**: https://megabank.co.jp
**Score**: 9/10

**Why They Fit**:
- 5000名規模の大手銀行
- 最近サイバー攻撃のニュース（日経記事、2024年1月）
- デジタル変革推進中
- セキュリティ予算増額発表

**Target Decision Makers**:
- CISO: 山田太郎 - linkedin.com/in/yamada-taro
- IT担当役員: 佐藤花子 - linkedin.com/in/sato-hanako

**Value Proposition**:
"MegaBankは最近のセキュリティインシデントを受けて、
AI駆動の脅威検知が急務です。私たちのプラットフォームは
大手銀行3行で導入済みで、平均95%の脅威検出率を実現しています。"

**Outreach Strategy**:
1. 業界カンファレンスでの対面接触
2. ホワイトペーパー「金融業界のAIセキュリティ」を送付
3. 既存顧客（競合銀行）のケーススタディ共有
4. POC（概念実証）提案

**Conversation Starter**:
"山田様、最近の金融業界のセキュリティ動向について記事を拝見しました。
当社は[競合銀行名]様で脅威検出率95%を達成しております。
詳細を共有させていただけますでしょうか。"
```

## リサーチソース

### 無料リソース
- LinkedIn Sales Navigator（トライアル）
- Crunchbase（基本情報）
- AngelList
- TechCrunch, VentureBeat
- 企業ウェブサイト
- GitHub（技術スタック）
- BuiltWith（使用技術）

### 有料リソース（推奨）
- ZoomInfo
- Apollo.io
- Clearbit
- Hunter.io（メールアドレス）

## ベストプラクティス

### 1. パーソナライゼーション

各企業に対して:
- 具体的な観察を含める
- 業界用語を使用
- 最近のニュース/イベントに言及

### 2. タイミング

優先的にアプローチすべきトリガー:
- 資金調達発表
- 幹部の交代
- 製品ローンチ
- オフィス拡張
- 買収/合併

### 3. マルチチャネルアプローチ

- LinkedIn接続
- メール
- Twitter/X
- 業界イベント
- 共通の人脈経由

### 4. フォローアップ

```
Day 1: 初回コンタクト
Day 3: 軽いリマインダー
Day 7: 価値追加（記事、ケーススタディ）
Day 14: 最終フォローアップ
```

## 出力フォーマット

### CRM-Ready CSV

```csv
Company,Website,Score,Industry,Size,Contact,Title,LinkedIn,Email,Notes
Acme Corp,acme.com,10,SaaS,150,Jane Smith,VP Eng,linkedin.com/in/janesmith,jane@acme.com,"Recently raised $20M, using 5+ tools"
```

### Notion Database

```markdown
| Company | Score | Contact | Strategy | Status |
|---------|-------|---------|----------|--------|
| Acme Corp | 10 | Jane Smith | LinkedIn → Demo | To Contact |
```

## トラブルシューティング

### リード情報が少ない
→ 業界を広げる、隣接市場を検討

### 意思決定者が見つからない
→ 企業ウェブサイトの"About"ページ、LinkedIn検索、Hunter.io

### スコアが低いリードばかり
→ ICP条件を再検討、ニッチを絞る

## 参考

- ICP作成ガイド: https://www.salesforce.com/resources/articles/ideal-customer-profile/
- LinkedIn Sales Navigator: https://business.linkedin.com/sales-solutions
- Crunchbase: https://www.crunchbase.com/
