# macbook-provisioning

macOS の環境構築を自動化するプロビジョニングリポジトリ。Homebrew、各種ツール設定、エディタ拡張などを一括管理する。

## クイックスタート

```bash
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
export PATH=$PATH:/opt/homebrew/bin
make setup              # Homebrew インストール
make package/install    # パッケージインストール
make link               # 設定ファイルのリンク作成
```

## コマンド一覧

### パッケージ管理

| コマンド | 説明 |
|---|---|
| `make package/install` | Brewfile からパッケージインストール |
| `make package/dump` | 現在のパッケージを Brewfile に書き出し |
| `make package/check` | Brewfile との差分確認 |
| `make package/cleanup` | 不要パッケージ削除 |
| `make npm/install` | グローバル npm パッケージインストール |
| `make yazi/install` | yazi プラグインインストール |

### 設定ファイルのリンク

| コマンド | 説明 |
|---|---|
| `make link` | 全設定をリンク（下記すべて実行） |
| `make link/home` | `~/` 直下にリンク（zshrc, gitconfig, vimrc, aerospace.toml, tmux.conf, bin/） |
| `make link/config` | `~/.config/` 配下にリンク（ghostty, borders, karabiner, peco, yazi, lazygit） |
| `make copy/claude` | `~/.claude/` へ設定をコピー |
| `make unlink` | リンク解除 |

### macOS システム設定

```bash
bash macos/defaults.sh  # macOS のシステム設定を適用（要再起動）
```

## ディレクトリ構成

```
├── Brewfile              # Homebrew パッケージ定義（VSCode/Cursor 拡張含む）
├── Makefile              # プロビジョニングタスク
├── zsh/                  # ~/.zshrc
├── git/                  # ~/.gitconfig
├── vim/                  # ~/.vimrc
├── tmux/                 # ~/.tmux.conf
├── ghostty/              # ~/.config/ghostty/config
├── aerospace/            # ~/.aerospace.toml
├── borders/              # ~/.config/borders/bordersrc
├── karabiner/            # ~/.config/karabiner/karabiner.json
├── peco/                 # ~/.config/peco/config.json
├── yazi/                 # ~/.config/yazi/*
├── lazygit/              # ~/.config/lazygit/config.yml
├── claude/               # ~/.claude/*
├── npm/                  # グローバル npm パッケージ一覧
├── macos/                # macOS 設定スクリプト
├── bin/                  # ユーティリティスクリプト（takt, mdview）
└── docs/                 # セットアップドキュメント
```

## ドキュメント

- [クリーンインストール前の準備](docs/pre-clean-install.md) - macOS リフレッシュ前のチェックリスト
- [新規 Mac セットアップ手順](docs/fresh-setup.md) - クリーンインストール後のセットアップ
- [AeroSpace ガイド](docs/aerospace-guide.md) - ウィンドウマネージャーの使い方
- [Claude Code Skills](docs/claude-code-skills.md) - Claude Code カスタムスキル

## 手動インストールが必要なアプリ

- [InYourFace](https://inyourface.app/) - カレンダー通知アプリ
