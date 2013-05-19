
#BEGIN PROMPT FUN STUFF
function pk_test_if_repo()
{
  git branch > /dev/null 2>&1
}
function pk_git_status()
{
  if  pk_test_if_repo ;
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
#Initial Answer isn't empty just because
ANSWER="00"

function pk_random_question()
{
  QUESTION="$(ruby ~/personal/mac_config/bash/ruby_prompt_question.rb)"
}

function pk_random_answer()
{
  ANSWER="$(ruby ~/personal/mac_config/bash/ruby_prompt_answer.rb ${QUESTION})"
}

function pk_timer_start {
  timer=${timer-$SECONDS}
}
function pk_timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

function pk_trap()
{
  printf '\e[0m'
  PK_COMMAND_HISTORY[1]=${PK_COMMAND_HISTORY[0]}
  PK_COMMAND_HISTORY[0]=$BASH_COMMAND
  pk_timer_start
}

function pk_run_time()
{
  END=`date +%s`
  echo "DURATION: $(($END-$START))"
}
function pk_ruby_prompt()
{
  pk_timer_stop
  if (( "${timer_show}" > "4" ))
  then
    terminal-notifier -message "'${PK_COMMAND_HISTORY[1]}' finished." > /dev/null
  fi
  pk_git_status
  CWD="$(dirs)"
  export PS1="\n\[\e[0;31m\]${timer_show} : ${RUBY_VERSION}\n$(ruby ~/personal/dotfiles/bash/scripts/ruby_prompt.rb ${CWD})${BRANCH}:\[\e[0;32m\]"
}
trap "pk_trap" DEBUG

#call this command every prompt
PROMPT_COMMAND=pk_ruby_prompt

