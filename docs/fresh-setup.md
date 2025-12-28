# 新規 Mac セットアップ手順

クリーンインストール後、または新しい Mac を設定する際の手順です。

## 前提条件

- macOS のクリーンインストールが完了している
- Apple ID でログイン済み
- インターネットに接続している

## 1. 初期設定

### Xcode Command Line Tools のインストール
ターミナルを開いて実行：
```bash
xcode-select --install
```

### このリポジトリをクローン
```bash
# ghq を使う場合（Homebrew インストール後）
ghq get git@github.com:chocopie116/macbook-provisioning.git

# または直接クローン
mkdir -p ~/.go/src/github.com/chocopie116
cd ~/.go/src/github.com/chocopie116
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
```

> **Note**: SSH 鍵がない場合は HTTPS でクローンするか、先に SSH 鍵を設定してください。

## 2. Homebrew セットアップ

### Homebrew のインストール
```bash
make setup
```

### PATH の設定
```bash
export PATH=$PATH:/opt/homebrew/bin
```

## 3. パッケージのインストール

### 全パッケージをインストール
```bash
make package/install
```

これにより以下がインストールされます：
- CLI ツール（brew formulae）
- GUI アプリケーション（brew casks）
- Mac App Store アプリ（mas）
- VSCode/Cursor 拡張

### npm パッケージのインストール
```bash
npm install -g aicommits
```

## 4. dotfiles の設定

### シンボリックリンクの作成
```bash
cd dotfiles
make install
```

これにより以下が設定されます：
- `~/.zshrc`
- `~/.vimrc`
- `~/.gitconfig`
- `~/.config/peco/config.json`

### zplug プラグインのインストール
新しいターミナルを開くと自動的にプラグインのインストールが促されます。

## 5. アプリケーション設定の復元

### Karabiner と Claude Code の設定
```bash
make restore
```

### macOS システム設定
```bash
cd dotfiles
bash .macos
```

> **Note**: 一部の設定は再起動後に有効になります。

## 6. 手動設定が必要な項目

### SSH 鍵の設定
```bash
# 新規作成する場合
ssh-keygen -t ed25519 -C "your_email@example.com"

# GitHub に公開鍵を登録
cat ~/.ssh/id_ed25519.pub | pbcopy
# GitHub > Settings > SSH and GPG keys で追加
```

### Git のローカル設定
```bash
# 必要に応じてローカル設定を作成
vim ~/.gitconfig.local
```

### アプリケーションへのログイン
- [ ] 1Password
- [ ] Dropbox
- [ ] Slack
- [ ] Discord
- [ ] その他のアプリ

### 手動インストールが必要なアプリ
- [InYourFace](https://inyourface.app/) - カレンダー通知アプリ

## 7. 確認作業

### 動作確認
- [ ] ターミナルで `peco` が動作するか
- [ ] `ghq get` でリポジトリをクローンできるか
- [ ] `git` のエイリアスが動作するか（`git s`, `git lg` など）
- [ ] Karabiner のキーマッピングが動作するか
- [ ] VSCode/Cursor で拡張が読み込まれているか

### asdf でのランタイム設定
```bash
# Node.js
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

# その他必要な言語
asdf plugin add python
asdf plugin add ruby
# ...
```

## クイックリファレンス

```bash
# すべてを一気にセットアップ（SSH 鍵設定済みの場合）
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
export PATH=$PATH:/opt/homebrew/bin
make setup
make package/install
cd dotfiles && make install && cd ..
make restore
npm install -g aicommits
```

## トラブルシューティング

### Homebrew のパスが通らない
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### mas でアプリがインストールできない
Mac App Store にログインしていることを確認してください。

### zplug のエラー
```bash
source /opt/homebrew/opt/zplug/init.zsh
zplug install
```
