# 実行時間短縮のために引数で動きを制御する
APP_STORE_INSTALL=false#App Storeのinstallは毎回上書きのためdefaultでは実行しない

install:
	HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -i hosts -vv  localhost.yml \
       -e 'APP_STORE_ISNTALL=$(APP_STORE_INSTALL)'
link:
	mkdir -p ~/.config/karabiner
	ln -sF $(PWD)/templates/karabiner.json ~/.config/karabiner/karabiner.json

awscli:
	curl -kL  https://bootstrap.pypa.io/get-pip.py | python
	sudo pip install awscli --upgrade --ignore-installed six

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
	@#@see https://github.com/zplug/zplug
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

neobundle:
	mkdir -p ~/.vim/bundle
	git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

#http://efcl.info/2015/02/01/github-open-pullrequest/
git-browse-remote:
	gem install $@


dotfiles:
	git clone git@github.com:chocopie116/dotfiles.git
	make -C ./dotfiles
