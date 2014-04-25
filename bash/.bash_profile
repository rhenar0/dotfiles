PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# git autocomplete
# must come before aliases
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

source ~/.rvm/scripts/rvm
source ~/.bash/scripts/private.bash
source ~/.bash/scripts/appfolio.bash
source ~/.bash/scripts/aliases.bash
source ~/.bash/scripts/prompt.bash
source ~/.bash/scripts/rake_autocomplete.bash

#macVim
export EDITOR='open -a MacVim'

#For npm
export PATH="/usr/local/share/npm/bin:$PATH"

# ignore same sucessive entries.
export HISTCONTROL=ignoreboth

export NGINX_VERSION=/usr/local/bin/nginx

# vim keybindings
set -o vi
bind -m vi-command i:previous-history
bind -m vi-command k:next-history
bind -m vi-command h:vi-insertion-mode
bind -m vi j:backward-char
bind -m vi H:vi-insert-beg

#sets up the color scheme for list export
LSCOLORS=gxfxcxdxbxegedabagacad

# Used for prompt:
#
# seem to be issues with having a trap linked to a
# function in a different source?
function __pk_trapper()
{
  __pk_trap
}
trap "__pk_trapper" DEBUG
