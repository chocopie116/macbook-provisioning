# 実行時間短縮のために引数で動きを制御する
APP_STORE_INSTALL=false#App Storeのinstallは毎回上書きのためdefaultでは実行しない

setup:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install cask ansible

install:
	HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -i hosts -vv  localhost.yml \
       -e 'APP_STORE_ISNTALL=$(APP_STORE_INSTALL)'
link:
	mkdir -p ~/.config/karabiner
	rm -f ~/.config/karabiner/karabiner.json
	ln -s $(PWD)/templates/karabiner.json ~/.config/karabiner/karabiner.json

go-tools:
	go get -u github.com/peco/peco/cmd/peco
	go get -u github.com/motemen/ghq
	go get -u github.com/nsf/gocode
	go get -u github.com/direnv/direnv
	go get -u github.com/rogpeppe/godef

zsh-tools:
	which zsh
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

#http://efcl.info/2015/02/01/github-open-pullrequest/
git-browse-remote:
	gem install $@

dotfiles:
	make -C ./dotfiles

vscode/install:
	rm ~/Library/Application\ Support/Code/User/setting.json
	ln -s $(PWD)/vscode/setting.json ~/Library/Application\ Support/Code/User/setting.json
	sh ./vscode/install.sh

import/vscode:
	code --list-extensions > ./vscode/extensions.txt

import/karabiner:
	cp -f ~/.config/karabiner/karabiner.json $(PWD)/templates/karabiner.json

