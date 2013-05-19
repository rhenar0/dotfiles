PATH="/usr/local/sbin:/usr/local/bin:$PATH"

source ~/.rvm/scripts/rvm
source ~/.bash/scripts/aliases.bash
source ~/.bash/scripts/prompt.bash
source ~/.bash/scripts/run_test.bash

#git autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

#macVim
export EDITOR='open -a MacVim'

#For npm
export PATH="/usr/local/share/npm/bin:$PATH"

# vim keybindings
set -o vi
bind -m vi-command i:previous-history
bind -m vi-command k:next-history
bind -m vi-command h:vi-insertion-mode
bind -m vi j:backward-char
bind -m vi H:vi-insert-beg

#sets up the color scheme for list export
LSCOLORS=gxfxcxdxbxegedabagacad
