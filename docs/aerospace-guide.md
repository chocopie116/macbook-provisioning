# AeroSpace ガイド

AeroSpace は i3 風の macOS 用タイル型ウィンドウマネージャー。

## 公式ドキュメント

- [GitHub](https://github.com/nikitabobko/AeroSpace)
- [Guide](https://nikitabobko.github.io/AeroSpace/guide)
- [Commands](https://nikitabobko.github.io/AeroSpace/commands)

## 基本概念

### ワークスペース
- macOS Spaces の問題を解決するため、独自の「ワークスペース」を実装
- 非アクティブなワークスペースのウィンドウは画面外に配置され、切り替え時に戻される

### タイリングツリーモデル
- i3 にインスパイアされた構造
- 各ワークスペースは単一のルートノードを含み、任意の深さでコンテナをネスト可能

### バインディングモード
- 異なるバインディングセットを複数作成可能
- モード切り替え時にアクティブなキーバインディングを変更
- デフォルトは `main` モード

### レイアウト
| レイアウト | 説明 |
|-----------|------|
| h_tiles | 水平タイル |
| v_tiles | 垂直タイル |
| h_accordion | 水平アコーディオン（積層表示）|
| v_accordion | 垂直アコーディオン（積層表示）|

## 設定ファイル

場所: `~/.aerospace.toml` または `~/.config/aerospace/aerospace.toml`

### 主要セクション
```toml
[key-mapping]      # キーボードレイアウト設定
[gaps]             # ウィンドウ間隔設定
[mode.main.binding] # メインモードのキーバインディング
[[on-window-detected]] # ウィンドウ検出時の自動処理
[workspace-to-monitor-force-assignment] # ワークスペースとモニターの割り当て
```

## キーバインディング

### 修飾キー
`cmd`, `alt`, `ctrl`, `shift`

### 使用可能なキー
- 文字: a-z
- 数字: 0-9
- F キー: f1-f20
- 特殊キー: minus, equal, period, comma, slash, backslash, quote, semicolon, backtick, leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
- 矢印: left, down, up, right

### 設定例
```toml
[mode.main.binding]
alt-h = 'focus left'
alt-shift-h = 'move left'
alt-1 = 'workspace 1'
alt-shift-1 = 'move-node-to-workspace 1'
```

## 主要コマンド

### ウィンドウ操作
| コマンド | 説明 | 例 |
|---------|------|-----|
| focus | フォーカス移動 | `focus left` |
| move | ウィンドウ移動 | `move right` |
| resize | サイズ変更 | `resize smart -50` |
| layout | レイアウト変更 | `layout tiles horizontal vertical` |
| fullscreen | フルスクリーン切替 | `fullscreen` |

### ワークスペース操作
| コマンド | 説明 | 例 |
|---------|------|-----|
| workspace | 切り替え | `workspace 1` |
| move-node-to-workspace | ウィンドウを移動 | `move-node-to-workspace 2` |
| workspace-back-and-forth | 前のワークスペースに戻る | - |

### モニター操作
| コマンド | 説明 | 例 |
|---------|------|-----|
| focus-monitor | モニターにフォーカス | `focus-monitor next` |
| move-node-to-monitor | ウィンドウをモニターへ | `move-node-to-monitor next` |
| move-workspace-to-monitor | ワークスペースをモニターへ | `move-workspace-to-monitor next` |

### その他
| コマンド | 説明 |
|---------|------|
| exec-and-forget | アプリ起動（設定内のみ）|
| reload-config | 設定再読み込み |
| mode | モード切り替え |

## ウィンドウ自動配置

```toml
[[on-window-detected]]
if.app-id = 'com.apple.Safari'
run = 'move-node-to-workspace W'
```

アプリ ID は `aerospace list-apps` で確認可能。

## シンプルな設定例

```toml
start-at-login = true

[gaps]
inner.horizontal = 5
inner.vertical = 5
outer.left = 5
outer.bottom = 5
outer.top = 5
outer.right = 5

[mode.main.binding]
# フォーカス移動
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'

# ウィンドウ移動
alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'

# ワークスペース（必要な分だけ）
alt-1 = 'workspace 1'
alt-2 = 'workspace 2'
alt-3 = 'workspace 3'

alt-shift-1 = 'move-node-to-workspace 1'
alt-shift-2 = 'move-node-to-workspace 2'
alt-shift-3 = 'move-node-to-workspace 3'

# レイアウト切り替え
alt-slash = 'layout tiles horizontal vertical'
```
