# 実行時間短縮のために引数で動きを制御する
APP_STORE_INSTALL=false#App Storeのinstallは毎回上書きのためdefaultでは実行しない

install:
	HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -i hosts -vv  localhost.yml \
       -e 'APP_STORE_ISNTALL=$(APP_STORE_INSTALL)'
link:
	mkdir -p ~/.config/karabiner
	rm -f ~/.config/karabiner/karabiner.json
	ln -s $(PWD)/templates/karabiner.json ~/.config/karabiner/karabiner.json

awscli:
	curl -kL  https://bootstrap.pypa.io/get-pip.py | python
	sudo pip3 install awscli --upgrade --ignore-installed six

gcloudcli:
	curl https://sdk.cloud.google.com | bash

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

vscode/restore:
	code --list-extensions > ./vscode/extensions.txt

