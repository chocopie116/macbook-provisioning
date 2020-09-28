# 実行時間短縮のために引数で動きを制御する
APP_STORE_INSTALL=false#App Storeのinstallは毎回上書きのためdefaultでは実行しない

setup:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install cask ansible

install:
	HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -i hosts -vv  localhost.yml \
       -e 'APP_STORE_ISNTALL=$(APP_STORE_INSTALL)'

#http://efcl.info/2015/02/01/github-open-pullrequest/
git-browse-remote:
	gem install $@


restore: _restore/karabiner _restore/vscode


_backup/vscode:
	code --list-extensions > ./vscode/extensions.txt

_backup/karabiner:
	cp -f ~/.config/karabiner/karabiner.json $(PWD)/templates/karabiner.json

_restore/karabiner:
	mkdir -p ~/.config/karabiner
	rm -f ~/.config/karabiner/karabiner.json
	ln -s $(PWD)/templates/karabiner.json ~/.config/karabiner/karabiner.json

_restore/vscode:
	rm ~/Library/Application\ Support/Code/User/setting.json
	ln -s $(PWD)/vscode/setting.json ~/Library/Application\ Support/Code/User/setting.json
	sh ./vscode/install.sh

