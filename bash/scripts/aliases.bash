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
function nuke()
{
  ps ax | grep $1 | awk '{print $1}' | xargs kill -9
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
  find . -name *$1*
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
function home()
{
  cd ~/home
}
function mylog()
{
  mvim ~/personal/notes/mylog.txt
}
function knowledge()
{
  mvim ~/personal/notes/knowledge.txt
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
alias g='git'

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
function mine()
{
  open -a RubyMine .
}
function ss()
{
  script/start
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
  cd ~/src/screenings_app
}
function vdr()
{
  cd ~/src/securedocs_bundle/trunk/apps/vdr
}
function sso()
{
  cd ~/src/securedocs_bundle/trunk/apps/sso
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
    brake db:migrate
    RAILS_ENV=test brake db:migrate db:rollback
    RAILS_ENV=test brake db:migrate
  fi
}
function broth()
{
  RAILS_ENV=development brake "$@"
  RAILS_ENV=test        brake "$@"
}
function up()
{
  svn up
  bundle install
  migrate
  rake_cache_store
}
function b()
{
  brake "$@"
}
function color_test()
{
  for code in $(seq -w 0 255); do for attr in 0 1; do printf "%s-%03s %bTest%b\n" "${attr}" "${code}" "\e[${attr};38;05;${code}m" "\e[m"; done; done | column -c $((COLUMNS*2))
}
function migrate()
{
  brake db:migrate; RAILS_ENV=test brake db:migrate
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
  ag '_pete'
  ag 'PETE'
  echo "----------------------"
  echo "tests match changes?"
}
