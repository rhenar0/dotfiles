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
function repeat()
{
  for i in $(seq $1)
  do
    echo "${@:2}"
    ${@:2}
  done
}
function retag()
{
  rm tags TAGS 2> /dev/null; ctags --exclude=.git --exclude=tmp --exclude='*.log' -R * `bundle show --paths`
}
function nuke()
{
  ps ax | grep $1 | awk '{print $1}' | xargs kill -9
}
function smart_bomb()
{
killall -15 $1 2> /dev/null || killall -2 $1 2> /dev/null || killall -1 $1 2> /dev/null || killall -9 $1 2> /dev/null
}
function nuke_server()
{
  smart_bomb passenger
  smart_bomb nginx
  smart_bomb multiplexer_ctl
  smart_bomb scheduler_ctl
  osascript -e 'tell application "Terminal" to quit'
}
function pf()
{
  ps ax | grep $1
}
function df()
{
  find . -type d -iname *$1*
}
function ff()
{
  find . -name *$1* 2> /dev/null
}
function analyze_history()
{
  history | awk '{print $2}' | awk 'BEGIN {FS="|"}{print $1}' | sort | uniq -c | sort -nr | head
}
function mvim()
{
  open -a MacVim $@
}
function koutouki()
{
  cd ~/home/koutouki
}
function mylog()
{
  mvim ~/personal/notes/mylog.txt
}
function knowledge()
{
  mvim ~/personal/notes/knowledge.txt
}
function todo()
{
  mvim ~/personal/notes/todo.txt
}
function fff()
{
  mvim ~/personal/notes/fff.txt
}
function mylife()
{
  mvim ~/Google\ Drive/journal.txt
}
function ls()
{
  # command means don't use user-defined functions
  command ls -G $@
}
function mouse_locator()
{
  nohup /Users/pete/Library/PreferencePanes/MouseLocator.prefPane/Contents/Resources/MouseLocatorAgent.app/Contents/MacOS/MouseLocatorAgent -psn_0_6026687 > /dev/null &
}
function cd..()
{
  cd ..
}
function ll()
{
  # this calls the ls defined above
  ls -al $@
}
alias g='git'

function diffme()
{
  git log --oneline HEAD ^master
}

# set up auto complete for my git alias
__git_complete g _git

function quiet()
{
  osascript -e "set Volume 0.05"
}
function console()
{
  pry -r ./config/environment
}
function ss()
{
  script/start
}
function property()
{
  cd ~/src/apm_bundle/apps/property
}
function tportal()
{
  cd ~/src/apm_bundle/apps/tportal
}
function listings()
{
  cd ~/src/apm_bundle/apps/listings
}
function screenings()
{
  cd ~/src/screenings_app
}
function brake()
{
  bundle exec rake $@
}
function trake()
{
  RAILS_ENV=test bundle exec rake $@
}
function mrm()
{
  brake db:migrate db:rollback
  if [ $? -eq 0 ];
  then
    broth db:migrate
  fi
}
function broth()
{
  RAILS_ENV=development brake "$@"
  RAILS_ENV=test        brake "$@"
}

function st()
{
   git status
}

function up_app()
{
  _GEM_STRING='.*'
  _GEM_STRING+=$1
  _GEM_STRING+='.*.gem'
  _MIGRATE_STRING='.*'
  _MIGRATE_STRING+=$1
  _MIGRATE_STRING+='.*db/migrate'

  $1;

  if grep --quiet $_GEM_STRING ~/tmp/up.log;
  then
    echo 'bundle'
    bundle install --local
  else
    echo 'no bundle'
  fi

  if grep --quiet $_MIGRATE_STRING ~/tmp/up.log;
  then
    echo 'migrate'
    migrate
  else
    echo 'no migrate'
  fi
}


function up()
{
  echo 'Rebasing'
  git svn rebase > ~/tmp/up.log

  echo 'update listings'
  up_app listings;
  echo 'update property'
  up_app property;
  echo 'update tportal'
  up_app tportal;
  property;
}

function b()
{
  brake "$@"
}
function color_test()
{
  for code in $(seq -w 0 255); do for attr in 0 1; do printf "%s-%03s %bTest%b\n" "${attr}" "${code}" "\e[${attr};38;05;${code}m" "\e[m"; done; done | column -c $((COLUMNS*2))
}
function selenium_restart()
{
  nuke selenium
  launchctl start homebrew.mxcl.selenium-server-standalone
}
function migrate()
{
  broth db:migrate;
}

# git commit checks

function git()
{
  if [[ $1 = 'commit' ]]
  then
    __pk_pre_commit_check
    read -p "Ready to commit?" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      printf "\n"
      echo $@
      command git "$@"
    fi
  else
    command git "$@"
  fi
}
function svn()
{
  if [[ $1 = 'commit' ]]
  then
    __pk_pre_commit_check
    read -p "Ready to commit?" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      printf "\n"
      command svn "$@"
    fi
  else
    command svn "$@"
  fi
}
function __pk_pre_commit_check()
{
  echo "----------------------"
  ag 'binding.pry'
  ag '_pete[^r]'
  ag 'PETE'
  echo "----------------------"
  echo "tests match changes?"
  git status
}
