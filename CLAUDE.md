# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

macOS の環境構築を自動化するプロビジョニングリポジトリ。Homebrew、dotfiles、VSCode 拡張、Karabiner 設定などを管理する。

## コマンド

### 初期セットアップ（新規 Mac）
```bash
make setup              # Homebrew インストール
make package/install    # brew bundle でパッケージインストール
npm install -g aicommits  # AI コミットメッセージ生成（git ac で使用）
```

### パッケージ管理
```bash
make package/install    # Brewfile からパッケージインストール
make package/dump       # 現在のパッケージを Brewfile に書き出し
make package/check      # Brewfile との差分確認
make package/cleanup    # 不要パッケージ削除
```

### dotfiles 設定
```bash
cd dotfiles && make install  # シンボリックリンク作成
cd dotfiles && make unlink   # シンボリックリンク削除
```

### 設定ファイル復元
```bash
make restore            # karabiner, claude 設定を復元
```

### macOS システム設定
```bash
cd dotfiles && bash .macos  # macOS のシステム設定を適用（要再起動）
```

## アーキテクチャ

```
├── Brewfile           # Homebrew パッケージ定義（VSCode/Cursor 拡張含む）
├── Makefile           # メインのプロビジョニングタスク
├── dotfiles/          # シェル・エディタ設定（zshrc, vimrc, gitconfig など）
│   └── Makefile       # dotfiles 用シンボリックリンク管理
├── templates/         # アプリ設定ファイル（karabiner.json）
└── .claude/           # Claude Code 設定（commands, settings）
```

## 基本方針

- 日本語で報告・質問する
- main に直接 commit しない
- シンプルに実装する
- 新規ファイル作成は慎重に判断する


