# 実行時間短縮のために引数で動きを制御する
HOMEBREW:=true
HOMEBREW_CASK:=true
APP_STORE_INSTALL=false #App Storeのinstallは毎回上書きのためdefaultでは実行しない

install:
	HOMEBREW_CASK_OPTS="--appdir=/Applications" ansible-playbook -i hosts -vv  localhost.yml \
       -e 'HOMEBREW=$(HOMEBREW) HOMEBREW_CASK=$(HOMEBREW_CASK) APP_STORE_ISNTALL=$(APP_STORE_INSTALL)'
