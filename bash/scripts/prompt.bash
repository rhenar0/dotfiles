
#BEGIN PROMPT FUN STUFF
function __pk_test_if_repo()
{
  git branch > /dev/null 2>&1
}
function __pk_git_status()
{
  if  __pk_test_if_repo ;
  then
    CLEAN="$(git status | grep 'clean')"
    if [[ $CLEAN = '' ]]
    then
      BRANCH="\n\[\e[0;31m\](\$(__git_ps1 '%s'))"
    else
      BRANCH="\n\[\e[0;34m\](\$(__git_ps1 '%s'))"
    fi
  else
    BRANCH="\n"
  fi
}

function __pk_timer_start {
  timer=${timer-$SECONDS}
}
function __pk_timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

function __pk_trap()
{
  printf '\e[0m'
  __PKCOMMAND_HISTORY[1]=${__PKCOMMAND_HISTORY[0]}
  __PKCOMMAND_HISTORY[0]=$BASH_COMMAND
  __pk_timer_start
}

function __pk_ruby_prompt()
{
  __pk_timer_stop
  if (( "${timer_show}" > "4" ))
  then
    terminal-notifier -message "'${__PKCOMMAND_HISTORY[1]}' finished." > /dev/null
  fi
  __pk_git_status
  CWD="$(dirs)"
  export PS1="\n\[\e[0;31m\]${timer_show} : ${RUBY_VERSION}\n$(ruby ~/.bash/scripts/ruby_prompt.rb ${CWD})${BRANCH}:\[\e[0;32m\]"
}
trap "__pk_trap" DEBUG

#call this command every prompt
PROMPT_COMMAND=__pk_ruby_prompt

