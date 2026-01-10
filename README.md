# macbook-provisioning

macOS の環境構築を自動化するプロビジョニングリポジトリ。

## ドキュメント

- [クリーンインストール前の準備](docs/pre-clean-install.md) - 年末の大掃除や macOS リフレッシュ前に
- [新規 Mac セットアップ手順](docs/fresh-setup.md) - クリーンインストール後のセットアップ

## クイックスタート

```bash
git clone git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
export PATH=$PATH:/opt/homebrew/bin
make setup
make package/install
cd dotfiles && make install && cd ..
make restore
```

## 手動インストールが必要なアプリ

- [InYourFace](https://inyourface.app/) - カレンダー通知アプリ

## 参考

- https://cookiebaker.hatenablog.com/entry/2019/04/12/220650
- http://t-wada.hatenablog.jp/entry/mac-provisioning-by-ansible
