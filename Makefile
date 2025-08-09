setup:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

package/install:
	brew bundle

package/cleanup:
	brew bundle cleanup

package/check:
	brew bundle check

package/dump:
	@#brew bundle dump --force --describe
	brew bundle dump --force

#http://efcl.info/2015/02/01/github-open-pullrequest/
git-browse-remote:
	gem install $@

restore: _restore/karabiner _restore/vscode _restore/claude

_backup/karabiner:
	cp -f ~/.config/karabiner/karabiner.json $(PWD)/templates/karabiner.json

_restore/karabiner:
	mkdir -p ~/.config/karabiner
	rm -f ~/.config/karabiner/karabiner.json
	ln -s $(PWD)/templates/karabiner.json ~/.config/karabiner/karabiner.json

_restore/claude:
	mkdir -p ~/.claude
	ln -sf $(PWD)/.claude/commands ~/.claude/commands
	ln -sf $(PWD)/.claude/CLAUDE.md ~/.claude/CLAUDE.md
	ln -sf $(PWD)/.claude/settings.local.json ~/.claude/settings.local.json

