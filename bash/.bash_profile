PATH="/usr/local/sbin:/usr/local/bin:$PATH:~/personal/android_tools/sdk/tools:~/personal/android_tools/sdk/platform-tools"

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

# speed up rails boot times
export RUBY_HEAP_SLOTS_INCREMENT=2000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_HEAP_FREE_MIN=1000000
export RUBY_GC_HEAP_INIT_SLOTS=8000000
export RUBY_GC_MALLOC_LIMIT=300000000

#macVim
export EDITOR='open -a MacVim'

#For npm
export PATH="/usr/local/share/npm/bin:$PATH"

# ignore same sucessive entries.
export HISTCONTROL=ignoreboth

export NGINX_VERSION=/usr/local/Cellar/nginx/1.4.3/bin/nginx

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
### /prompt

# must be last because reasons
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

ulimit -n 9999
