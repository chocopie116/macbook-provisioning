# クリーンインストール前の準備

macOS をクリーンインストールする前に実施する手順です。年末の大掃除などで Mac をリフレッシュする際に参照してください。

## 1. データのバックアップ

### 必須のバックアップ
- [ ] iCloud Drive の同期が完了していることを確認
- [ ] 1Password のバックアップ（クラウド同期確認）
- [ ] SSH 鍵のバックアップ（`~/.ssh/`）
- [ ] GPG 鍵のバックアップ（使用している場合）
- [ ] ローカルのみに存在する重要ファイルの確認

### 確認すべき設定
- [ ] Karabiner の設定が最新か確認（`templates/karabiner.json`）
- [ ] VSCode/Cursor の拡張が Brewfile に反映されているか
- [ ] dotfiles の変更がコミットされているか

## 2. パッケージの精査

### 現在のパッケージを確認
```bash
# 現在インストールされているパッケージを Brewfile に出力
make package/dump

# 差分を確認
git diff Brewfile
```

### 不要パッケージの削除
```bash
# Brewfile にないパッケージを確認
make package/check

# 不要パッケージを削除
make package/cleanup
```

### パッケージリストのレビュー
Brewfile を開いて以下を確認：
- [ ] 使っていないアプリはないか
- [ ] 重複している機能のアプリはないか
- [ ] VSCode/Cursor 拡張で不要なものはないか

## 3. 設定のエクスポート

### このリポジトリを更新
```bash
cd ~/path/to/macbook-provisioning

# Brewfile を更新
make package/dump

# 変更をコミット
git add -A
git commit -m "クリーンインストール前のパッケージ更新"
git push
```

### アプリ固有の設定
- [ ] BetterTouchTool の設定エクスポート
- [ ] Raycast の設定エクスポート（クラウド同期推奨）
- [ ] その他カスタマイズしたアプリの設定

## 4. アカウント情報の確認

以下のサービスにログインできることを確認：
- [ ] Apple ID
- [ ] GitHub（SSH 鍵または認証アプリ）
- [ ] 1Password
- [ ] Dropbox
- [ ] その他必要なサービス

## 5. macOS のクリーンインストール

### インストール方法
1. Mac をシャットダウン
2. 電源ボタンを長押しして起動オプションを表示（Apple Silicon Mac）
3. 「オプション」を選択
4. ディスクユーティリティで Macintosh HD を消去
5. macOS を再インストール

### 参考
- [Mac を消去して工場出荷時の設定にリセットする - Apple サポート](https://support.apple.com/ja-jp/HT212749)

## チェックリスト

クリーンインストール前の最終確認：

- [ ] このリポジトリが最新の状態で push されている
- [ ] iCloud の同期が完了している
- [ ] 重要なローカルファイルがバックアップされている
- [ ] 各サービスへのログイン情報が確認できる
- [ ] SSH 鍵がバックアップされている（または新規作成する準備ができている）
