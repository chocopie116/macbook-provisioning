# macbook-provisioning

## how to use
```
cd ~/
mkdir workspaces
cd workspaces
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
source ~/.bashrc
brew doctor
brew install git
brew install ansible
git@github.com:chocopie116/macbook-provisioning.git
cd macbook-provisioning
make install
```
## 参考
http://t-wada.hatenablog.jp/entry/mac-provisioning-by-ansible


## brew caskにないアプリ

[https://github.com/caskroom/homebrew-cask](https://github.com/caskroom/homebrew-cask/issues/new?title=Cask%20request%3A%20%5Bapp%20name%20here%5D&body=%23%23%23%20Cask%20details%0A%0A%28Please%20fill%20out%20as%20much%20as%20possible%29%0A%0A%2A%2AName%2A%2A%3A%0A%0A%2A%2AHomepage%2A%2A%3A%0A%0A%2A%2ADownload%20URL%2A%2A%3A%0A%0A%2A%2ADescription%2A%2A%3A%0A)より


