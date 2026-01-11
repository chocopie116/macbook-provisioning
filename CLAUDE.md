# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

macOS の環境構築を自動化するプロビジョニングリポジトリ。Homebrew、各種ツール設定、VSCode 拡張などを管理する。

## コマンド

### 初期セットアップ（新規 Mac）
```bash
make setup              # Homebrew インストール
make package/install    # brew bundle でパッケージインストール
make link               # 設定ファイルのシンボリックリンク作成
```

### パッケージ管理
```bash
make package/install    # Brewfile からパッケージインストール
make package/dump       # 現在のパッケージを Brewfile に書き出し
make package/check      # Brewfile との差分確認
make package/cleanup    # 不要パッケージ削除
```

### 設定ファイルのリンク
```bash
make link               # 全設定をリンク
make link/home          # ~/直下にリンク（zshrc, gitconfig, vimrc, aerospace.toml）
make link/config        # ~/.config/配下にリンク（ghostty, borders, karabiner, peco, yazi）
make link/claude        # ~/.claude/配下にリンク
make unlink             # リンク解除
```

### yaziプラグイン管理
```bash
make yazi/install       # yaziプラグインをインストール（ya packコマンド使用）
```

**インストールされるプラグイン:**
- git.yazi: Git統合機能
- full-border.yazi: 完全な境界線表示
- smart-enter.yazi: エンターキー挙動の最適化
- toggle-pane.yazi: プレビューペイン表示制御

### macOS システム設定
```bash
bash macos/defaults.sh  # macOS のシステム設定を適用（要再起動）
```

## アーキテクチャ

```
├── Brewfile            # Homebrew パッケージ定義（VSCode/Cursor 拡張含む）
├── Makefile            # プロビジョニングタスク（link/unlink/package管理）
│
├── zsh/                # ~/.zshrc
├── git/                # ~/.gitconfig
├── vim/                # ~/.vimrc
├── ghostty/            # ~/.config/ghostty/config
├── aerospace/          # ~/.aerospace.toml
├── borders/            # ~/.config/borders/bordersrc
├── karabiner/          # ~/.config/karabiner/karabiner.json
├── peco/               # ~/.config/peco/config.json
├── yazi/               # ~/.config/yazi/*
├── claude/             # ~/.claude/*
├── macos/              # macOS設定スクリプト
│
├── bin/                # ユーティリティスクリプト
└── docs/               # セットアップドキュメント
```

