all: install

install: link

PWD:=$(shell pwd)
srcs:=gitconfig vimrc zshrc

link:
	mkdir -p $(HOME)/.config/peco/
	ln -Fs $(PWD)/peco.config.json $(HOME)/.config/peco/config.json
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

unlink:
	$(foreach src, $(srcs), rm  $(HOME)/.$(src);)

