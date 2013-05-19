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

function pk_test_find_path_to_test_folder
{
  PK_PATH_REGEX=$(ls -al $PK_RELATIVE_PATH | grep "^dr" | grep "\ test$")
  if [[ $PK_PATH_REGEX = '' ]]
  then
    PK_ROOT_REGEX=$(ls -al $PK_RELATIVE_PATH | grep "^dr" | grep "\ usr$")

    if [[ $PK_ROOT_REGEX = '' ]]
    then
      PK_RELATIVE_PATH="${PK_RELATIVE_PATH}../"
      pk_test_find_path_to_test_folder

    else
      PK_UNABLE_TO_LOCATE_ROOT_FOLDER=1
    fi
  fi
}
function t()
{
  PK_UNABLE_TO_LOCATE_ROOT_FOLDER=0
  PK_RELATIVE_PATH="./"
  pk_test_find_path_to_test_folder
  if [[ $PK_UNABLE_TO_LOCATE_ROOT_FOLDER = 1 ]]
  then
    echo "Cannot locate test folder"
    return
  fi

  cd $PK_RELATIVE_PATH

  if [[ $1 = '' ]]
  then
    pk_test_handle_default

  elif [[ $1 =~ \.rb$ ]]
  then
    pk_test_handle_file_case $1

  else
    pk_test_handle_function_case $1

  fi
  cd - > /dev/null
}

function pk_test_handle_default()
{
  pk_test_run
}

function pk_test_handle_file_case()
{
  if [[ $1 =~ [\/] ]]
  then
    pk_test_handle_file_path $1

  else
    pk_test_handle_file_name $1

  fi
}

function pk_test_handle_file_path()
{
  # full path given
  if [[ -e "$1" ]]
  then
    pk_test_run $1
  else
    echo "File does not exist."
  fi
}

function pk_test_handle_file_name()
{
  # file name given, not full path

  PK_TEST_FILE="$(find . -name $1)"

  if [[ $PK_TEST_FILE = '' ]]
  then
    # file not found
    echo "file $1 not found"

  elif [[ $PK_TEST_FILE =~ \.rb(.)+\.rb ]]
  then
    # found multiple files
    echo "$PK_TEST_FILE"
    echo "Multiple test files of that name exist..."
    echo "Please use the full path."

  else
    # found the file
    pk_test_run $PK_TEST_FILE

  fi
}

function pk_test_handle_function_case()
{
  # given a test name, no file given

  PK_REGEX="^[\ ]+def[^\n]+$1"
  PK_TEST_FILE=$(ag "$PK_REGEX" ./test | awk -F':' '{print $1}')
  PK_TEST_FUNCTION=$(ag "$PK_REGEX" ./test | awk -F':' '{print $3}')
  PK_TEST_FUNCTION="${PK_TEST_FUNCTION:6}"

  if [[ $PK_TEST_FILE = '' ]]
  then
    # couldn't find specified test
    echo "Could not find test function matching: $1"

  elif [[ $PK_TEST_FILE =~ (.)+\.rb(.)+ ]]
  then
    # multiple tests found
    ag "$PK_REGEX" ./test
    echo "Mulitple test files contain a test of that name."
    echo "This script can't handle that :("

  else
    # found the specified test
    pk_test_run $PK_TEST_FILE $PK_TEST_FUNCTION
  fi
}

function pk_test_run()
{
  PK_RAKE_TASK="bundle exec rake test"
  if [[ $1 != '' ]]
  then
    PK_RAKE_TASK="$PK_RAKE_TASK TEST=$1"
    if [[ $2 != '' ]]
    then
      PK_RAKE_TASK="$PK_RAKE_TASK TESTOPTS=--name=$2"
    fi
  fi
  echo $PK_RAKE_TASK
  ${PK_RAKE_TASK}
}

function pk_test_test()
{
  echo "default =>"
  t
  echo "............"

  echo "full path =>"
  t test/unit/document_test.rb
  echo "............"

  echo "bad path =>"
  t test/unit/steve.rb
  echo "............"

  echo "filename =>"
  t document_test.rb
  echo "............"

  echo "many files =>"
  t user_test.rb
  echo "............"

  echo "test name =>"
  t pdf_engine
  echo "............"

  echo "many tests =>"
  t watermark_pdf
  echo "............"

  echo "no test =>"
  t steve
  echo "............"

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
