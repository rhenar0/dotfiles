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
function koutouki()
{
  cd ~/home/koutouki
}
function home()
{
  cd ~/home
}
function mylog()
{
  mvim ~/personal/notes/mylog.txt
}
function mylife()
{
  mvim ~/Google\ Drive/journal.txt
}
function notes()
{
  mvim ~/home/notes/juntobox.txt
}
function ls()
{
  # command means don't use user-defined functions
  command ls -G $@
}
function cd..()
{
  cd ..
}
function ll()
{
  # this calls the ls defined above
  ls -al
}
function be()
{
  bundle exec $@
}
function g()
{
  git $@
}
function quiet()
{
  osascript -e "set Volume 0.05"
}
function console()
{
  pry -r ./config/environment
}
function gems()
{
  mvim ~/.rvm/gems/ree-1.8.7-2010.02/gems/
}

#from Brynjar
function mine()
{
  open -a RubyMine .
}
function kp()
{
  ps aux | grep [n]ginx | awk '{print $2}' | xargs kill -9
}
function ss()
{
  script/start
}
function aggregator()
{
  cd ~/src/appfolio/aggregator_app/trunk
}
function biz()
{
  cd ~/src/appfolio/biz_app/trunk
}
function cashier()
{
  cd ~/src/appfolio/cashier_app/trunk
}
function cotasignup()
{
  cd ~/src/appfolio/cotasignupp_app/trunk
}
function cota()
{
  cd ~/src/appfolio_git/rentapp_bundle/apps/cota
}
function apply()
{
  cd ~/src/appfolio/rentapp_bundle/trunk/apps/apply
}
function property()
{
  cd ~/src/property/property_bundle/trunk/apps/property
}
function tportal()
{
  cd ~/src/property/property_bundle/trunk/apps/tportal
}
function listings()
{
  cd ~/src/property/property_bundle/trunk/apps/listings
}
function screenings()
{
  cd ~/src/appfolio_git/screenings_app
}
function screenings_template()
{
  cd ~/src/property/screenings_template/trunk
}
function vdr()
{
  cd ~/src/vdr/vdr_app/
}
function sso()
{
  cd ~/src/vdr/sso_app/
}
function rails_code()
{
  cd ~/src/rails
}
function be()
{
  bundle exec $@
}
function delete_old_branches()
{
  git branch --merged master | grep -v 'master$' | xargs git branch -d
}
function brake()
{
  bundle exec rake $@
}

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
