# macbook-provisioning

macOS の環境構築を自動化するプロビジョニングリポジトリ。
Homebrew、dotfiles、各種ツール設定を一括管理し、新規 Mac のセットアップや環境の再現性を実現します。

## 📚 目次

- [初回セットアップ](#初回セットアップ)
- [日常的な操作](#日常的な操作)
- [管理対象](#管理対象)
- [ドキュメント](#ドキュメント)

---

## 初回セットアップ

新しい Mac やクリーンインストール後のセットアップ手順です。

### 前提条件

1. [1Password](https://1password.com/downloads/mac/) をインストール・ログイン済み
2. SSH 鍵を設定済み（GitHub にも登録済み）

```bash
# SSH 鍵の新規作成（必要な場合）
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub | pbcopy
# GitHub > Settings > SSH and GPG keys で公開鍵を追加
```

### セットアップ実行

```bash
# 1. リポジトリをクローン
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning

# 2. Homebrew をインストール
make setup
export PATH=$PATH:/opt/homebrew/bin

# 3. パッケージをインストール
make package/install

# 4. 設定ファイルをリンク
make link

# 5. macOS システム設定を適用（オプション・要再起動）
bash macos/defaults.sh
```

詳細は [新規 Mac セットアップ手順](docs/fresh-setup.md) を参照。

---

## 日常的な操作

### パッケージ管理

```bash
# パッケージをインストール（Brewfile から）
make package/install

# 現在インストール済みのパッケージを Brewfile に書き出し
make package/dump

# Brewfile との差分を確認
make package/check

# Brewfile にないパッケージを削除
make package/cleanup
```

### 設定ファイルの管理

```bash
# 全設定ファイルをリンク
make link

# ~/直下のみリンク（.zshrc, .gitconfig, .vimrc, .aerospace.toml など）
make link/home

# ~/.config/配下のみリンク（ghostty, karabiner, yazi など）
make link/config

# ~/.claude/配下をコピー（スキルは除外）
make copy/claude

# すべてのリンクを解除
make unlink
```

### その他

```bash
# yazi プラグインをインストール
make yazi/install

# グローバル npm パッケージをインストール
make npm/install
```

---

## 管理対象

### アプリケーション・パッケージ

- Homebrew パッケージ（CLI ツール、cask アプリ）
- VSCode/Cursor 拡張機能
- npm グローバルパッケージ
- yazi プラグイン

### 設定ファイル（dotfiles）

| カテゴリ | 配置先 | 内容 |
|---------|--------|------|
| **シェル** | `~/.zshrc` | zsh 設定 |
| **Git** | `~/.gitconfig` | Git グローバル設定 |
| **エディタ** | `~/.vimrc`, `~/.tmux.conf` | Vim, tmux 設定 |
| **ターミナル** | `~/.config/ghostty/` | Ghostty 設定 |
| **ウィンドウ管理** | `~/.aerospace.toml`, `~/.config/borders/` | AeroSpace, JankyBorders 設定 |
| **キーバインド** | `~/.config/karabiner/` | Karabiner-Elements 設定 |
| **ファイラー** | `~/.config/yazi/` | yazi 設定・プラグイン |
| **その他** | `~/.config/peco/`, `~/.config/lazygit/` | peco, lazygit 設定 |
| **Claude Code** | `~/.claude/` | AI エージェント設定・スキル |

### macOS システム設定

`macos/defaults.sh` で以下を設定（要再起動）:

- Dock の挙動
- Finder の表示設定
- キーリピート速度
- その他システムデフォルト

---

## ドキュメント

- **[クリーンインストール前の準備](docs/pre-clean-install.md)** - macOS リフレッシュ前のチェックリスト
- **[新規 Mac セットアップ手順](docs/fresh-setup.md)** - 詳細なセットアップガイド
- **[AeroSpace ガイド](docs/aerospace-guide.md)** - ウィンドウ管理の使い方
- **[Claude Code スキル](docs/claude-code-skills.md)** - AI エージェントのカスタムスキル

---

## 手動インストールが必要なアプリ

以下のアプリは Homebrew で管理していないため、手動インストールが必要です:

- [InYourFace](https://inyourface.app/) - カレンダー通知アプリ
