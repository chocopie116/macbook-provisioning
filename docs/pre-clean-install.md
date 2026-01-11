# クリーンインストール前の準備

macOS をクリーンインストールする前に実施する手順。

## 1. バックアップ確認

- [ ] iCloud Drive の同期完了
- [ ] 1Password のクラウド同期確認
- [ ] SSH 鍵のバックアップ（`~/.ssh/`）

## 2. 設定の確認

- [ ] Karabiner の設定が最新か（`karabiner/karabiner.json`）
- [ ] VSCode/Cursor 拡張が Brewfile に反映されているか
- [ ] dotfiles の変更がコミット済みか

## 3. パッケージの更新

```bash
# 現在のパッケージを Brewfile に出力
make package/dump

# 差分を確認してコミット
git diff Brewfile
git add -A && git commit -m "update packages" && git push
```

## 4. アプリ設定のエクスポート

### Raycast
1. 「Export Settings & Data」で `.rayconfig` を iCloud Drive に保存

## 5. クリーンインストール

1. Mac をシャットダウン
2. 電源ボタン長押しで起動オプション表示
3. ディスクユーティリティで消去 → macOS 再インストール

参考: [Mac を消去して工場出荷時の設定にリセットする](https://support.apple.com/ja-jp/HT212749)
