#BEGIN PROMPT FUN STUFF
__PK_TERMINAL_NOTIFIER_PATH='/Users/pete/.rvm/gems/ruby-2.1.2/gems/terminal-notifier-1.6.1/bin/terminal-notifier'
__PK_RUBY_PATH='/Users/pete/.rvm/rubies/ruby-2.1.2/bin/ruby'

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
  # save the second to last one, otherwise grabs
  # a prompt command
  __PK_COMMAND_HISTORY[1]=${__PK_COMMAND_HISTORY[0]}
  __PK_COMMAND_HISTORY[0]=$BASH_COMMAND
  __pk_timer_start
}

function __pk_ruby_prompt()
{
  __pk_exit_code=$?
  __pk_timer_stop
  if (( "${timer_show}" > "4" ))
  then
    $($__PK_TERMINAL_NOTIFIER_PATH -message "'${__PK_COMMAND_HISTORY[1]}' finished with exit code ${__pk_exit_code}." > /dev/null)
  fi
  __pk_git_status
  CWD="$(dirs)"
  export PS1="\n\[\e[0;31m\]${timer_show} : $(rvm-prompt)\n$($__PK_RUBY_PATH ~/.bash/scripts/ruby_prompt.rb ${CWD})${BRANCH}:\[\e[0;32m\]"
}

#call this command every prompt
PROMPT_COMMAND=__pk_ruby_prompt

