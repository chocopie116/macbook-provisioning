PWD := $(shell pwd)

.PHONY: link unlink link/home link/config copy/claude setup package/install package/cleanup package/check package/dump yazi/install npm/install kanata/setup

link: link/home link/config copy/claude

link/home:
	ln -Fs $(PWD)/zsh/zshrc $(HOME)/.zshrc
	ln -Fs $(PWD)/git/gitconfig $(HOME)/.gitconfig
	ln -Fs $(PWD)/vim/vimrc $(HOME)/.vimrc
	ln -Fs $(PWD)/aerospace/aerospace.toml $(HOME)/.aerospace.toml
	mkdir -p $(HOME)/bin
	ln -Fs $(PWD)/bin/takt $(HOME)/bin/takt
	ln -Fs $(PWD)/bin/mdview $(HOME)/bin/mdview
	ln -Fs $(PWD)/tmux/tmux.conf $(HOME)/.tmux.conf

link/config:
	mkdir -p $(HOME)/.config/ghostty
	ln -Fs $(PWD)/ghostty/config $(HOME)/.config/ghostty/config
	mkdir -p $(HOME)/.config/borders
	ln -Fs $(PWD)/borders/bordersrc $(HOME)/.config/borders/bordersrc
	mkdir -p $(HOME)/.config/kanata
	ln -Fs $(PWD)/kanata/macbook.kbd $(HOME)/.config/kanata/macbook.kbd
	ln -Fs $(PWD)/kanata/keychron.kbd $(HOME)/.config/kanata/keychron.kbd
	mkdir -p $(HOME)/.config/peco
	ln -Fs $(PWD)/peco/config.json $(HOME)/.config/peco/config.json
	mkdir -p $(HOME)/.config/yazi
	ln -Fs $(PWD)/yazi/yazi.toml $(HOME)/.config/yazi/yazi.toml
	ln -Fs $(PWD)/yazi/keymap.toml $(HOME)/.config/yazi/keymap.toml
	ln -Fs $(PWD)/yazi/init.lua $(HOME)/.config/yazi/init.lua
	ln -Fs $(PWD)/yazi/package.toml $(HOME)/.config/yazi/package.toml
	mkdir -p $(HOME)/.config/lazygit
	ln -Fs $(PWD)/lazygit/config.yml $(HOME)/.config/lazygit/config.yml

copy/claude:
	mkdir -p $(HOME)/.claude
	rsync -a --delete --exclude='skills/' $(PWD)/claude/ $(HOME)/.claude/

unlink:
	rm -f $(HOME)/.zshrc $(HOME)/.gitconfig $(HOME)/.vimrc $(HOME)/.aerospace.toml
	rm -f $(HOME)/bin/takt
	rm -f $(HOME)/.tmux.conf
	rm -f $(HOME)/.config/ghostty/config
	rm -f $(HOME)/.config/borders/bordersrc
	rm -rf $(HOME)/.config/kanata
	rm -f $(HOME)/.config/peco/config.json
	rm -rf $(HOME)/.config/yazi
	rm -f $(HOME)/.claude/CLAUDE.md $(HOME)/.claude/settings.json $(HOME)/.claude/statusline.sh $(HOME)/.claude/notify.sh
	rm -rf $(HOME)/.claude/agents

setup:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

package/install:
	brew bundle

package/cleanup:
	brew bundle cleanup

package/check:
	brew bundle check

package/dump:
	brew bundle dump --force

yazi/install:
	ya pkg install

npm/install:
	cat npm/global-packages.txt | xargs npm install -g

kanata/setup:
	sudo cp $(PWD)/kanata/com.kanata.macbook.plist /Library/LaunchDaemons/
	sudo cp $(PWD)/kanata/com.kanata.keychron.plist /Library/LaunchDaemons/
	sudo chown root:wheel /Library/LaunchDaemons/com.kanata.*.plist
	sudo launchctl bootstrap system /Library/LaunchDaemons/com.kanata.macbook.plist
	sudo launchctl enable system/com.kanata.macbook
	sudo launchctl bootstrap system /Library/LaunchDaemons/com.kanata.keychron.plist
	sudo launchctl enable system/com.kanata.keychron

