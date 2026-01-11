# 新規 Mac セットアップ手順

クリーンインストール後、または新しい Mac を設定する際の手順。

## 1. 事前準備

1. [1Password](https://1password.com/downloads/mac/) をインストールしてログイン
2. SSH 鍵を復元（1Password から）または新規作成

```bash
# 新規作成の場合
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub | pbcopy
# GitHub > Settings > SSH and GPG keys で追加
```

## 2. リポジトリのクローン

```bash
mkdir -p ~/.go/src/github.com/chocopie116
cd ~/.go/src/github.com/chocopie116
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
```

## 3. セットアップ実行

```bash
# Homebrew インストール
xcode-select --install
make setup
export PATH=$PATH:/opt/homebrew/bin

# パッケージインストール
make package/install

# 設定ファイルのリンク
make link

# macOS システム設定（オプション）
bash macos/defaults.sh
```

## 4. 追加設定

### Raycast
1. Raycast を開く（⌘ + Space）
2. 「Import Settings & Data」で `.rayconfig` ファイルをインポート

### asdf ランタイム
```bash
asdf plugin add nodejs && asdf install nodejs latest && asdf global nodejs latest
```

## クイックリファレンス

```bash
# SSH 設定後に実行
mkdir -p ~/.go/src/github.com/chocopie116
cd ~/.go/src/github.com/chocopie116
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
xcode-select --install
make setup
export PATH=$PATH:/opt/homebrew/bin
make package/install
make link
```
