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

unlink:
	$(foreach src, $(srcs), rm  $(HOME)/.$(src);)
	$(foreach src, $(claude_srcs), rm  $(HOME)/.claude/$(src);)

