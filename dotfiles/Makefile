all: install

install: link

PWD:=$(shell pwd)
REPO_ROOT:=$(shell dirname $(PWD))
srcs:=gitconfig vimrc zshrc
claude_srcs:=commands settings.json statusline.sh notify.sh

link:
	mkdir -p $(HOME)/.config/peco/
	ln -Fs $(PWD)/peco.config.json $(HOME)/.config/peco/config.json
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)
	mkdir -p $(HOME)/.claude/
	$(foreach src,$(claude_srcs),ln -Fs $(REPO_ROOT)/.claude/$(src) $(HOME)/.claude/$(src);)
	mkdir -p $(HOME)/.config/ghostty/
	ln -Fs $(PWD)/ghostty.config $(HOME)/.config/ghostty/config
	mkdir -p $(HOME)/.config/borders/
	ln -Fs $(PWD)/bordersrc $(HOME)/.config/borders/bordersrc
	ln -Fs $(PWD)/aerospace.toml $(HOME)/.aerospace.toml
	mkdir -p $(HOME)/.config/karabiner/
	ln -Fs $(PWD)/karabiner.json $(HOME)/.config/karabiner/karabiner.json
	mkdir -p $(HOME)/.config/yazi/
	ln -Fs $(PWD)/yazi/yazi.toml $(HOME)/.config/yazi/yazi.toml
	ln -Fs $(PWD)/yazi/keymap.toml $(HOME)/.config/yazi/keymap.toml
	ln -Fs $(PWD)/yazi/init.lua $(HOME)/.config/yazi/init.lua

unlink:
	$(foreach src, $(srcs), rm  $(HOME)/.$(src);)
	$(foreach src, $(claude_srcs), rm  $(HOME)/.claude/$(src);)
	rm $(HOME)/.config/karabiner/karabiner.json

