all: install

install: link

PWD:=$(shell pwd)
srcs:=gitconfig my.cnf tigrc tmux.conf vimrc zshrc tigrc

setup:
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/install.sh
	$ sh /tmp/install.sh

link:
	mkdir -p $(HOME)/.config/peco/
	ln -Fs $(PWD)/peco.config.json $(HOME)/.config/peco/config.json
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

unlink:
	$(foreach src, $(srcs), rm  $(HOME)/.$(src);)

