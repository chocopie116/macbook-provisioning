# 実行時間短縮のために引数で動きを制御する
APP_STORE_INSTALL=false#App Storeのinstallは毎回上書きのためdefaultでは実行しない

install:
	HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -i hosts -vv  localhost.yml \
       -e 'APP_STORE_ISNTALL=$(APP_STORE_INSTALL)'
link:
	mkdir -p ~/.config/karabiner
	ln -sF $(PWD)/templates/karabiner.json ~/.config/karabiner/karabiner.json
