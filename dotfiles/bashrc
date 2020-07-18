# deployed by ansible!
# http://unix.stackexchange.com/questions/30925/in-bash-when-to-alias-when-to-script-and-when-to-write-a-function

# https://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-wrapping-items-with-spaces-in-single-quotes
export QUOTING_STYLE=literal

export HISTFILESIZE=40000
export HISTSIZE=40001
export HISTTIMEFORMAT="%T " # "
export EDITOR=vim
export PATH="$HOME/.local/bin:$PATH"

# ps except deselect kernel kthreadd
# use ps2 f for tree listing without kernel processes
# hmmm, 'ps xf' appears to do similar and better...
alias ps2='ps --ppid 2 -p 2 --deselect'

alias xclip='xclip -selection clipboard'

alias dmesg='dmesg -T --color=always'
alias less='less -R'
alias vim='vim -p'
alias vims='vim -p -S ./mysession.vim'

alias top='top -d 1'
# alias feh='feh -F -Z -d --keep-zoom-vp'
# alias feh='feh -F -Z -d'
alias feh='feh -F -d --draw-exif'
alias iftop='iftop -B -P -N'

# shortcuts
alias g=git
alias s=sudo
alias l=ls

# alias c=clear   use ctrl-L instead
alias f='find . -iname'


# OLD
# Single key aliases are idempotent, no rm,cp,mv etc
# alias l=less
# alias v='vim -p'
# alias p=ping
# alias a=apt-get         # ansible
# alias c=cat             # cd or cat? config_stufff
# alias f=find
# alias h=history
# alias ps='ps auxf'
# alias sv='sudo vim -p'
# TODO issue ss conflicts with sockets util, also
# alias ss='sudo -s'
# alias se='sudo -sE'
# alias sc='systemctl'

# sc conflicts with systemctl and /usr/bin/sc
alias sc=systemctl    # shadows /usr/bin/sc
alias jc=journalctl
alias mc=machinectl
alias lc=loginctl

# useful to decode and list nix paths, and assign them etc
# dirs=$(path)
alias path='for i in $( echo "$PATH" | sed "s/\:/ /g" ); do echo $i; done'

# just use  cd $(mktemp -d ) if really needed
# alias tmp='export T=$(mktemp -d); pushd $T'

# figure out ip doing nat
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias myip2='curl https://api.ipify.org/?format=json'
alias myip3='curl https://ident.me'
alias myip4="curl -s http://www.ip-adress.eu/ | grep My | sed 's/.*\">//' "

# ping

# ping gateway
function pgw() {
  gateway=$( ip route | grep '^default' | cut -d ' ' -f 3  )
  ping -i 0.7 $gateway
}
# ping dns server
function pdns() {
  dns=$( grep '^nameserver' /etc/resolv.conf | head -n 1 | cut -d ' ' -f 2 )
  ping -i 0.7  $dns
}

# ping google
alias p8="ping -i 0.7 8.8.8.8"
# ping opendns
alias p9="ping -i 0.7 208.67.222.222"

# watch ping google
alias wp8='watch -n 0.7 ping -i 0.7 -c 1 8.8.8.8'

# generate a password
alias mkpass="cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -n 1"

# print text doc
alias pr='a2ps -1 -R -f 9'

# record screen video
alias rec="ffmpeg  -f x11grab -s 1920x1200 -r 25 -i :0.0 output.mp4"
alias rec2="ffmpeg -f x11grab -s 1920x1080 -r 25 -i :0.0 output.mp4"

# screen capture, emits a png in folder
alias cap="scrot -d 5"

# eg. cat /usr/share/zoneinfo/America/Los_Angeles
# tzselect
alias frtime='TZ=Europe/Paris date'
alias uktime='TZ=Europe/London date'
# broken, ny gives aest time?
# alias nytime='TZ=America/New_York date'
alias latime='TZ=America/Los_Angeles date'
alias autime='TZ=Australia/Hobart date'
alias hcmtime='TZ=Asia/Ho_Chi_Minh date'
alias utctime='date --utc'


alias ls='ls --group-directories-first --color=always' # or less, or locate?

# add numeric permissions. (eg 755) to ls
function ls2() {
  ls -lh --group-directories-first --color=always $@ | awk '{
    k=0;
    for(i=0;i<=8;i++)
      k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));
      if(k)
        printf("%0o ",k);
      print
    }'
}


# format in columns really useful for reading output of 'ip route'
# eg. ip route | cols
cols() {
    column -t $1
}

# https://serverfault.com/questions/116775/sudo-as-different-user-and-running-screen
# alias screen2='script -q -c screen /dev/null'

function screen2() {
  /usr/bin/script -q -c "/usr/bin/screen ${*}" /dev/null
}

# tail files in a directory. note, this won't catch newly created files
# https://unix.stackexchange.com/questions/39729/monitor-files-%c3%a0-la-tail-f-in-an-entire-directory-even-new-ones
# eg.
# taildir /var/log/
function taildir() {
  tail -f -n 0  $( find "${*}" -type f )
}

# mkdir and cd into it
mkcd() {
    mkdir $1
    cd $1
}

# cd n directory levels up using numerical argument
# change name from cdup to up?
up() {
    if [ -z "$1" ]; then
      cd ..
    else
      for i in $(seq 1 "$1"); do cd ..; done
    fi
}

# read log files, by first sorting, and then unzipping if necessary
# TODO - maybe remove since it's a bit specific
# need to cd to log location before
function logs() {
  zcat -f $(ls -rv "$1"*) | less;
}


# shell colors...
RED="\[\033[1;31m\]"
YELLOW="\[\033[1;33m\]"
GREEN="\[\033[1;32m\]"
BLUE="\[\033[1;34m\]"
NO_COLOUR="\[\033[0m\]"

get_prompt_color() {
    if [ `id -u` -eq 0 ]; then
        echo "$RED"
    else
        echo "$GREEN"
    fi
}

PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}$(get_prompt_color)\u@\h${NO_COLOUR}:${BLUE}\w${NO_COLOUR}\$ "


#
# include more specific bash aliaes
# for i in $( seq 1 10 ); do
#  f="$HOME/.bash_aliases$i"
#  if [ -f "$f" ]; then
#    # echo "including $f"   # stuff's up ssh...
#    . "$f"
#  fi
#done


