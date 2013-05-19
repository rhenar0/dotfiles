PATH="/usr/local/sbin:/usr/local/bin:$PATH"

source ~/.rvm/scripts/rvm
#git autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

#macVim
alias mvim='open -a MacVim'
export EDITOR='open -a MacVim'

#For npm
export PATH="/usr/local/share/npm/bin:$PATH"

# my aliases
alias koutouki='cd ~/home/koutouki'
alias home='cd ~/home'
alias mylog='mvim ~/personal/notes/mylog.txt'
alias mylife='mvim ~/Google\ Drive/journal.txt'
alias notes='mvim ~/home/notes/juntobox.txt'
alias ls='ls -G'
alias cd..='cd ..'
#alias .='cd ..'
alias ll='ls -all'
alias rspecf='rspec --format documentation -d --color'
alias be='bundle exec'
alias g='git'
alias quiet='osascript -e "set Volume 0.05"'
alias console='pry -r ./config/environment'
alias gems='mvim ~/.rvm/gems/ree-1.8.7-2010.02/gems/'

#from Brynjar
alias m='open -a RubyMine .'
alias kp="ps aux | grep [n]ginx | awk '{print $2}' | xargs kill -9"
alias si='EDITOR=vim svn propedit svn:ignore .'
alias ss='script/start'
alias aggregator='cd ~/src/appfolio/aggregator_app/trunk'
alias biz='cd ~/src/appfolio/biz_app/trunk'
alias cashier='cd ~/src/appfolio/cashier_app/trunk'
alias cotasignup='cd ~/src/appfolio/cotasignupp_app/trunk'
alias cota='cd ~/src/appfolio_git/rentapp_bundle/apps/cota'
alias apply='cd ~/src/appfolio/rentapp_bundle/trunk/apps/apply'
alias property='cd ~/src/property/property_bundle/trunk/apps/property'
alias tportal='cd ~/src/property/property_bundle/trunk/apps/tportal'
alias listings='cd ~/src/property/property_bundle/trunk/apps/listings'
alias screenings='cd ~/src/appfolio_git/screenings_app'
alias screenings_template='cd ~/src/property/screenings_template/trunk'
alias vdr='cd ~/src/vdr/vdr_app/'
alias sso='cd ~/src/vdr/sso_app/'
alias rails_code='cd ~/src/rails'
alias st='if [ -e ./.svn ]
then
  svnst;
else
  git status;
fi'
alias be="bundle exec"
alias delete_old_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d"
alias brake="bundle exec rake"

set -o vi
bind -m vi-command i:previous-history
bind -m vi-command k:next-history
bind -m vi-command h:vi-insertion-mode
bind -m vi j:backward-char
bind -m vi H:vi-insert-beg

# set up auto complete for my git alias
__git_complete g _git

#sets up the color scheme for list export
LSCOLORS=gxfxcxdxbxegedabagacad

#
# Run a specific test
# Should handle cases better (e.g. what if test not found?)

function t()
{
  TEST_FUNCTION=''
  TEST_FILE=''

  if [[ $1 = '' ]]
  then
    echo "Running unit tests."
    bundle exec rake
    return
  fi

  if [[ $1 =~ [\/] ]]
  then
    # full path given
    TEST_FILE="$1"
    if [[ -e "$TEST_FILE" ]]
    then
      pk_rake_test_file
      return
    else
      echo "File does not exist."
      return
    fi

  fi

  if [[ $1 =~ \.rb$ ]]
  then
    # file name given, not full path

    TEST_FILE="$(find . -name $1)"

    if [[ $TEST_FILE = '' ]]
    then
      # file not found
      echo "file $1 not found"
      return
    fi

    if [[ $TEST_FILE =~ \n(.)+\n ]]
    then
      # found multiple files
      echo "$TEST_FILE"
      echo "Multiple test files of that name exist..."
      echo "Please use the full path."
      return
    fi

    # found the file
    pk_rake_test_file

  else
    # given a test name, no file given

    TEST_FUNCTION=$1
    TEST_FILE="$(ag def[^\n]+$1 ./test | grep .rb | awk -F':' '{print $1}')"
    TEST_FUNCTION="$(ag def[^\n]+$1 ./test | grep .rb | awk -F':' '{print $3}')"
    TEST_FUNCTION="${TEST_FUNCTION:6}"

    if [[ $TEST_FILE = '' ]]
    then
      # couldn't find specified test
      echo "Could not find test function matching: $1"
      return
    fi

    if [[ $TEST_FILE =~ (.)+\.rb(.)+ ]]
    then
      # multiple tests found
      echo "$TEST_FILE"
      echo "Mulitple test files contain a test of that name."
      echo "This script can't handle that :("
      return
    fi

    # found the specified test
    pk_rake_specific_test
  fi
}

function pk_rake_test_file()
{
  echo "bundle exec rake test TEST=$TEST_FILE"
  bundle exec rake test TEST=$TEST_FILE
}
function pk_rake_specific_test()
{
  echo "bundle exec rake test TEST=$TEST_FILE TESTOPTS=--name=$TEST_FUNCTION"
  bundle exec rake test TEST=$TEST_FILE TESTOPTS=--name=$TEST_FUNCTION
}

#
# END run specific test

function nuke()
{
  ps ax | grep $1 | awk '{print $1}' | xargs kill -9
}

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
  pk_git_status
  CWD="$(dirs)"
  # run the decoration script with mri ruby, cause jruby is sloooow
  export PS1="\n\[\e[0;31m\]${timer_show} : ${RUBY_VERSION}\n$(ruby ~/personal/dotfiles/bash/scripts/ruby_prompt.rb ${CWD})${BRANCH}:\[\e[0;32m\]"
}
trap "pk_trap" DEBUG

#call this command every prompt
PROMPT_COMMAND=pk_ruby_prompt

function clean_up()
{
  # delete stupid Google Drive duplicates (1)
  find . | ack '\(1\)' > ~/todel.txt;
  cat ~/todel.txt | while read line; do  rm -rf \"$line\" ; done;
  rm -rf ~/todel.txt
}

alias mvim='open -a MacVim'
#create file and/or open in macvim
function e
{
  if [[ $1 = '' ]]
  then
    echo "silly silly silly"
  else
    touch $1;
    mvim $1;
  fi
}
