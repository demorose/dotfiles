[ -z "$PS1" ] && return

case "$TERM" in
    rxvt-unicode-256color)
        TERM=rxvt-unicode
        ;;
    rxvt-256color)
        TERM=rxvt-unicode
        ;;
esac
#############
# Set COLOR #
#############
# Reset
COLOR_OFF='\e[0m'       # Text Reset

# Regular Colors
BLACK='\e[0;30m'        # Black
RED='\e[0;31m'          # Red
GREEN='\e[0;32m'        # Green
YELLOW='\e[0;33m'       # Yellow
BLUE='\e[0;34m'         # Blue
PURPLE='\e[0;35m'       # Purple
CYAN='\e[0;36m'         # Cyan
WHITE='\e[0;37m'        # White

# Bold
BBLACK='\e[1;30m'       # Black
BRED='\e[1;31m'         # Red
BGREEN='\e[1;32m'       # Green
BYELLOW='\e[1;33m'      # Yellow
BBLUE='\e[1;34m'        # Blue
BPURPLE='\e[1;35m'      # Purple
BCYAN='\e[1;36m'        # Cyan
BWHITE='\e[1;37m'       # White

# Underline
UBLACK='\e[4;30m'       # Black
URED='\e[4;31m'         # Red
UGREEN='\e[4;32m'       # Green
UYELLOW='\e[4;33m'      # Yellow
UBLUE='\e[4;34m'        # Blue
UPURPLE='\e[4;35m'      # Purple
UCYAN='\e[4;36m'        # Cyan
UWHITE='\e[4;37m'       # White

# Background
ON_BLACK='\e[40m'       # Black
ON_RED='\e[41m'         # Red
ON_GREEN='\e[42m'       # Green
ON_YELLOW='\e[43m'      # Yellow
ON_BLUE='\e[44m'        # Blue
ON_PURPLE='\e[45m'      # Purple
ON_CYAN='\e[46m'        # Cyan
ON_WHITE='\e[47m'       # White

# High Intensity
IBLACK='\e[0;90m'       # Black
IRED='\e[0;91m'         # Red
IGREEN='\e[0;92m'       # Green
IYELLOW='\e[0;93m'      # Yellow
IBLUE='\e[0;94m'        # Blue
IPURPLE='\e[0;95m'      # Purple
ICYAN='\e[0;96m'        # Cyan
IWHITE='\e[0;97m'       # White

# Bold High Intensity
BIBLACK='\e[1;90m'      # Black
BIRED='\e[1;91m'        # Red
BIGREEN='\e[1;92m'      # Green
BIYELLOW='\e[1;93m'     # Yellow
BIBLUE='\e[1;94m'       # Blue
BIPURPLE='\e[1;95m'     # Purple
BICYAN='\e[1;96m'       # Cyan
BIWHITE='\e[1;97m'      # White

# High Intensity backgrounds
ON_IBLACK='\e[0;100m'   # Black
ON_IRED='\e[0;101m'     # Red
ON_IGREEN='\e[0;102m'   # Green
ON_IYELLOW='\e[0;103m'  # Yellow
ON_IBLUE='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
ON_ICYAN='\e[0;106m'    # Cyan
ON_IWHITE='\e[0;107m'   # White

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#########
# START #
#########

if hash xrdb 2>/dev/null; then
    xrdb ~/.Xdefault
fi
#command fortune | cowsay -f tux
echo -e "$PURPLE$(cat ~/.reminder)"
export PATH=$PATH:~/scripts

#        VAR

EDITOR=/usr/bin/vim
BROWSER=chromium

#        PS1

function parse_git_branch {
timeout 0.5s git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function parse_git_local_state {
gitLocalCommit=`git log HEAD --not --remotes --simplify-by-decoration --oneline | wc -l`
if [[ $gitLocalCommit -gt 0 ]]; then echo -n "$IRED!"; fi
}

function parse_git_status {
gitStatus=`timeout 0.5s git status --porcelain`
gitRetVal=$?
if [ $gitRetVal -ne 0 ]; then
    return $gitRetVal;
fi
nodeleted=`echo "$gitStatus" | grep -E "^(D)" | wc -l`
noupdated=`echo "$gitStatus" | grep -E "^ (M|D)" | wc -l`
nocommitted=`echo "$gitStatus" | grep -E "^(M|A|R|C)" | wc -l`
noadded=`echo "$gitStatus" | grep -E "^(\?)" | wc -l`

if [[ $nocommitted -gt 0 ]]; then echo -n "+"; fi
if [[ $noupdated -gt 0 ]]; then echo -n "*"; fi
if [[ $nodeleted -gt 0 ]]; then echo -n "-"; fi
if [[ $noadded -gt 0 ]]; then echo -n "?"; fi
}

function get_ip {
ip a s  | awk '/inet / {print $2}' | grep -v '127.0.0.1' | head -n 1
}

function test_network {
timeout 0.2s ping -q -w 1 -c 1 www.google.fr > /dev/null 2>&1 && echo -ne "$BBLUE" || echo -ne "$BBLACK"
}

# To truncate PWD if > 1/3 of screen
function truncate_pwd
{
    newPWD=`pwd|sed -e "s!$HOME!~!"`
    local pwdmaxlen=$((${COLUMNS:-70}/3))
    if [ ${#newPWD} -gt $pwdmaxlen ]
    then
        newPWD="...${newPWD: -$pwdmaxlen}"
    fi
    nbFiles=$(ls -1 | wc -l | sed 's: ::g')
    sizeFiles=$(ls -lah | grep -m 1 total | sed 's/total //')
}

prompt() {
    RET_COLOR='$(if [[ $RET = 0 ]]; then echo -ne "\[$GREEN\]"; else echo -ne "\[$RED\]"; fi;)'
    RET_SMILEY='$(if [[ $RET = 0 ]]; then echo -ne "\[$GREEN\]"; else echo -ne "\[$RED\]"; fi;)'
    GIT_INFO='$(if [[ ! -z $(parse_git_branch) ]]; then echo -ne "\[$USERCOLOR\]][\[$IYELLOW\]$(parse_git_branch):$(parse_git_status)"$(parse_git_local_state); fi;)'
    IP='$(if [[ ! -z $(get_ip) ]]; then echo -ne "\[$USERCOLOR\]][$(test_network)$(get_ip)"; fi;)'
    # Waiting for a better design
    # if [[ -w "${PWD}" ]]; then
    #     PERM=$BLUE"rw"
    # else
    #     PERM=$YELLOW"ro"
    # fi
    PERM=''

    # If root: red, else: blue
    if [[ $EUID -ne 0 ]]; then
        USERCOLOR=$CYAN
        BUSERCOLOR=$BCYAN
    else
        USERCOLOR=$RED
        BUSERCOLOR=$BRED
    fi
    # for console of less than 100 col
    if [[ $COLUMNS -lt 100 ]]; then

        PS1="\n\[$USERCOLOR\]┌[\u]["
        PS1=$PS1"\[$BLUE\]\${newPWD}"
        PS1=$PS1"\[$USERCOLOR\]]\n└─[$RET_COLOR\!\[$USERCOLOR\]]─┨"

        # for console of more than 100 col
    else
        PS1="\n\[$USERCOLOR\]┌[\u]"

        PS1=$PS1"[\[$YELLOW\]\t "

        #If over ssh, then add ssh:// on hostname
        if [ -n "$SSH_CLIENT" ]; then
            PS1=$PS1"\[$UBLUE\]ssh://\h"
        else
            PS1=$PS1"\[$UBLUE\]\h"
        fi
        PS1=$PS1"$BLUE:\${newPWD}$PERM"
        PS1=$PS1"$IP"
        PS1=$PS1"$GIT_INFO"

        PS1=$PS1"\[$USERCOLOR\]][\[$PURPLE\]\$(who | wc -l)\[$USERCOLOR\]]"
        PS1=$PS1" $RET_SMILEY"

        PS1=$PS1"\[$USERCOLOR\] \n└─"
        PS1=$PS1"[`temp=$(tty) ; echo ${temp:5}`:\[$BLUE\]\!\[$USERCOLOR\]]─┨\[$USERCOLOR\]"
    fi
}

# Retrive return value, truncate pwd, Responsive prompt
PROMPT_COMMAND='RET=$?;truncate_pwd;prompt;'

# Reset color for command output
trap 'echo -ne "$COLOR_OFF"' DEBUG

###########
# ALIASES #
###########

#     CONNECTIONS
alias ssh="ssh -A"

#      UTILITIES
alias ls="ls --color=auto"
alias ll='ls -l'
alias la='ls -a'
alias ..='cd ..'
alias cd..='cd ..'
alias l='ls'
alias lla='ls -a -l'
alias vi='vim'
alias top='htop'
alias lt='tty-clock -s -r; vlock'
alias fuck='sudo "$BASH" -c "$(history -p !!)"'
alias damn='yes | "$BASH" -c "$(history -p !!)"'

#      OPTIONS
HISTSIZE=10000

#############
# FUNCTIONS #
#############

# repeat :
# usage -> repeat x cmd args

repeat() {
    n=$1
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
}

# decider :
# usage -> decider list,of,things,to,randomize

decider() {
    list=$1
    echo $list | tr ',' '\n' | sort -R | head -1
}

# music_ping :
# usage -> music_ping SomeDomain.Name

music_ping() {
    ping -i0.2 $1 |awk -F[=\ ] '/time=/{t=$(NF-1);f=3000-14*log(t^27);c="play -qn synth pl " f " fade 0.1 1 &";print $0;system(c)}'
}

# remind :
# usage -> remind "a string"

remind(){
    if [ "$#" == "0" ]; then
        echo -e "$PURPLE$(cat ~/.reminder)$COLOR_OFF";
    else
        echo "$@" >> ~/.reminder;
    fi
}

setBacklight() {
    if [ "$#" == "0" ]; then
        echo "need one argument"
    else
        k_lvl="/sys/class/leds/samsung::kbd_backlight/brightness"
        sudo chmod 666 $k_lvl
        echo $1 > $k_lvl
    fi
}

function ssh_tmux() {
ssh -A -t "$1" tmux a || ssh -A -t "$1" tmux;
}

. ~/.local_bashrc
