############
# Util
###########

function ls()
{
  # command means don't use user-defined functions
  command ls -alhG $@
}

function nuke()
{
  ps ax | grep -i $1 | awk '{print $1}' | xargs kill -9
}

function smart_bomb()
{
  killall -15 $1 2> /dev/null || killall -2 $1 2> /dev/null || killall -1 $1 2> /dev/null || killall -9 $1 2> /dev/null
}

function pf()
{
  if [ "$#" -eq 1 ]
  then
      ps -efww | head -1 && ps -efww | grep $1
  else
      ps -efww
  fi
}
function df()
{
  find . -type d -iname *$1*
}
function ff()
{
  find . -name *$1* 2> /dev/null
}


function selenium_restart()
{
  nuke selenium
  launchctl start homebrew.mxcl.selenium-server-standalone
}

############
# Novel
###########

function repeat()
{
  for i in $(seq $1)
  do
    echo "${@:2}"
    ${@:2}
  done
}

function analyze_history()
{
  history | awk '{print $2}' | awk 'BEGIN {FS="|"}{print $1}' | sort | uniq -c | sort -nr | head
}

function quiet()
{
  osascript -e "set Volume 0.05"
}

function color_test()
{
  for code in $(seq -w 0 255); do for attr in 0 1; do printf "%s-%03s %bTest%b\n" "${attr}" "${code}" "\e[${attr};38;05;${code}m" "\e[m"; done; done | column -c $((COLUMNS*2))
}

function mouse_locator()
{
  nohup /Users/pete/Library/PreferencePanes/MouseLocator.prefPane/Contents/Resources/MouseLocatorAgent.app/Contents/MacOS/MouseLocatorAgent -psn_0_6026687 > /dev/null &
}
############
# Editor
###########
function mvim()
{
  open -a MacVim $@
}

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

function retag()
{
  rm tags TAGS 2> /dev/null; ctags --exclude=.git --exclude=tmp --exclude='*.log' -R * `bundle show --paths` 2> /dev/null
}

alias g='git'
# set up auto complete for my git alias
__git_complete g _git
__git_complete git_up _git

############
# For Pairing
###########
function st()
{
   git status
}

############
# Ruby/Rails
###########

function be()
{
  bundle exec "$@"
}

function brake()
{
  bundle exec rake $@
}

function trake()
{
  RAILS_ENV=test bundle exec rake $@
}

function broth()
{
  RAILS_ENV=development brake "$@"
  RAILS_ENV=test        brake "$@"
}

function b()
{
  brake "$@"
}

function migrate()
{
  broth db:migrate;
}

function mrm()
{
  brake db:migrate db:rollback
  if [ $? -eq 0 ];
  then
    broth db:migrate
  fi
}

# from sfb_scripts.gem
# https://github.com/petekinnecom/sfb_scripts
alias t='test_runner find'

function up()
{
  app_up "$@"
}
