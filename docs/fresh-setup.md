# 新規 Mac セットアップ手順

クリーンインストール後、または新しい Mac を設定する際の手順です。

## 前提条件

- macOS のクリーンインストールが完了している
- Apple ID でログイン済み
- インターネットに接続している

## 1. 最初に手動でインストールするアプリ

### 1Password のインストール
1. [1Password](https://1password.com/downloads/mac/) をダウンロードしてインストール
2. アカウントにログイン
3. SSH 鍵や各種認証情報にアクセスできることを確認

### Chrome のインストール
1. Safari で [Google Chrome](https://www.google.com/chrome/) をダウンロード
2. インストールして既定のブラウザに設定

## 2. SSH 鍵の設定

### 1Password から SSH 鍵を復元する場合
1. 1Password から SSH 秘密鍵をエクスポート
2. `~/.ssh/` に配置して権限を設定：
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
# 1Password から鍵をコピー後
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### 新規に SSH 鍵を作成する場合
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub | pbcopy
```
GitHub > Settings > SSH and GPG keys で公開鍵を追加

### SSH 接続テスト
```bash
ssh -T git@github.com
# "Hi username!" と表示されれば成功
```

## 3. リポジトリのクローン

```bash
mkdir -p ~/.go/src/github.com/chocopie116
cd ~/.go/src/github.com/chocopie116
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
```

## 4. Homebrew セットアップ

### Xcode Command Line Tools と Homebrew のインストール
```bash
xcode-select --install  # 必要に応じて
make setup
export PATH=$PATH:/opt/homebrew/bin
```

## 5. パッケージのインストール

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

## 6. dotfiles の設定

### シンボリックリンクの作成
```bash
cd dotfiles
make install
cd ..
```

これにより以下が設定されます：
- `~/.zshrc`
- `~/.vimrc`
- `~/.gitconfig`
- `~/.config/peco/config.json`

### zplug プラグインのインストール
新しいターミナルを開くと自動的にプラグインのインストールが促されます。

## 7. アプリケーション設定の復元

### Karabiner と Claude Code の設定
```bash
make restore
```

### Raycast の設定インポート
1. Raycast を開く（⌘ + Space）
2. 「Import Settings & Data」と入力して実行
3. 保存した `.rayconfig` ファイルを選択
4. エクスポート時に設定したパスフレーズを入力

### macOS システム設定
```bash
cd dotfiles
bash .macos
```

> **Note**: 一部の設定は再起動後に有効になります。

## 8. その他の設定

### Git のローカル設定
```bash
# 必要に応じてローカル設定を作成
vim ~/.gitconfig.local
```

### アプリケーションへのログイン
- [ ] Dropbox
- [ ] Slack
- [ ] Discord
- [ ] Notion
- [ ] その他のアプリ

### 手動インストールが必要なアプリ
- [InYourFace](https://inyourface.app/) - カレンダー通知アプリ

## 9. 確認作業

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
# 1Password と Chrome を手動インストール後
# SSH 鍵を設定してから以下を実行

mkdir -p ~/.go/src/github.com/chocopie116
cd ~/.go/src/github.com/chocopie116
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning

xcode-select --install
make setup
export PATH=$PATH:/opt/homebrew/bin
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
