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

#from Brynjar
function mine()
{
  open -a RubyMine .
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
  cd ~/src/screenings_app
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
function be()
{
  bundle exec $@
}
function brake()
{
  bundle exec rake $@
}
function color_test()
{
  for code in $(seq -w 0 255); do for attr in 0 1; do printf "%s-%03s %bTest%b\n" "${attr}" "${code}" "\e[${attr};38;05;${code}m" "\e[m"; done; done | column -c $((COLUMNS*2))
}
