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
COLOR_OFF='\033[0m'       # Text Reset

# Regular Colors
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White

# Bold
BBLACK='\033[1;30m'       # Black
BRED='\033[1;31m'         # Red
BGREEN='\033[1;32m'       # Green
BYELLOW='\033[1;33m'      # Yellow
BBLUE='\033[1;34m'        # Blue
BPURPLE='\033[1;35m'      # Purple
BCYAN='\033[1;36m'        # Cyan
BWHITE='\033[1;37m'       # White

# Underline
UBLACK='\033[4;30m'       # Black
URED='\033[4;31m'         # Red
UGREEN='\033[4;32m'       # Green
UYELLOW='\033[4;33m'      # Yellow
UBLUE='\033[4;34m'        # Blue
UPURPLE='\033[4;35m'      # Purple
UCYAN='\033[4;36m'        # Cyan
UWHITE='\033[4;37m'       # White

# Background
ON_BLACK='\033[40m'       # Black
ON_RED='\033[41m'         # Red
ON_GREEN='\033[42m'       # Green
ON_YELLOW='\033[43m'      # Yellow
ON_BLUE='\033[44m'        # Blue
ON_PURPLE='\033[45m'      # Purple
ON_CYAN='\033[46m'        # Cyan
ON_WHITE='\033[47m'       # White

# High Intensity
IBLACK='\033[0;90m'       # Black
IRED='\033[0;91m'         # Red
IGREEN='\033[0;92m'       # Green
IYELLOW='\033[0;93m'      # Yellow
IBLUE='\033[0;94m'        # Blue
IPURPLE='\033[0;95m'      # Purple
ICYAN='\033[0;96m'        # Cyan
IWHITE='\033[0;97m'       # White

# Bold High Intensity
BIBLACK='\033[1;90m'      # Black
BIRED='\033[1;91m'        # Red
BIGREEN='\033[1;92m'      # Green
BIYELLOW='\033[1;93m'     # Yellow
BIBLUE='\033[1;94m'       # Blue
BIPURPLE='\033[1;95m'     # Purple
BICYAN='\033[1;96m'       # Cyan
BIWHITE='\033[1;97m'      # White

# High Intensity backgrounds
ON_IBLACK='\033[0;100m'   # Black
ON_IRED='\033[0;101m'     # Red
ON_IGREEN='\033[0;102m'   # Green
ON_IYELLOW='\033[0;103m'  # Yellow
ON_IBLUE='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
ON_ICYAN='\033[0;106m'    # Cyan
ON_IWHITE='\033[0;107m'   # White

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

# Reminder
echo -e "$PURPLE$(cat ~/.reminder)"

#        VAR

EDITOR=/usr/bin/vim
BROWSER=chromium
PROMPT_TAG=''
TAG_COLOR=$BBLUE

#        PS1

# Var for __git_ps1

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose
export GIT_PS1_DESCRIBE_STYLE=branch
# Only works if __git_ps1 is called from PROMPT_COMMAND
# export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1

ALWAYS_USE_MINI=false

git_status() {
    if hash __git_ps1 2>/dev/null; then
        __git_ps1 "%s"
    fi
}

get_ip() {
    if hash ip 2> /dev/null; then
        ip a s  | awk '/inet / {print $2}' | grep -v '127.0.0.1' | head -n 1
    else
        ifconfig  | awk '/inet / {print $2}' | sed 's/adr://' | grep -v '127.0.0.1' |head -n 1
    fi
}

test_network() {
    NETWORK_OK=$BBLUE
    NETWORK_KO=$BBLACK
    timeout 0.2s ping -q -w 1 -c 1 www.google.fr > /dev/null 2>&1 && echo "$NETWORK_OK" || echo "$NETWORK_KO"
}

# To truncate PWD if ~> 1/3 of screen
truncate_pwd() {
    newPWD=`pwd|sed -e "s!$HOME!~!"`
    local pwdmaxlen=$((${COLUMNS:-100}/3))
    if [ ${#newPWD} -gt $pwdmaxlen ]
    then
        newPWD="...${newPWD:-$pwdmaxlen}"
    fi
}

prompt() {
    RET_COLOR='$(if [[ $RET = 0 ]]; then echo -ne "\[$GREEN\]"; else echo -ne "\[$RED\]"; fi;)'
    RET_SMILEY='$(if [[ $RET = 0 ]]; then echo -ne "\[$GREEN\]"; else echo -ne "\[$RED\]"; fi;)'
    GIT_INFO='$(if [[ ! -z $(git_status) ]]; then echo -ne "\[$USERCOLOR\]][\[$IYELLOW\]$(git_status)"; fi;)'
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
    if [[ $COLUMNS -lt 100 || $ALWAYS_USE_MINI = true ]]; then

        PS1="\n\[$USERCOLOR\]┌"
        if [ -n "$PROMPT_TAG" ]; then
            PS1=$PS1"\[$USERCOLOR\][\[$TAG_COLOR\]$PROMPT_TAG\[$USERCOLOR\]]"
        fi
        PS1=$PS1"[\u]["
        PS1=$PS1"\[$BLUE\]\${newPWD}"
        PS1=$PS1"\[$USERCOLOR\]]\n└─[$RET_COLOR\!\[$USERCOLOR\]]─┨"

        # for console of more than 100 col
    else
        PS1="\n\[$USERCOLOR\]┌"
        if [ -n "$PROMPT_TAG" ]; then
            PS1=$PS1"\[$USERCOLOR\][\[$TAG_COLOR\]$PROMPT_TAG\[$USERCOLOR\]]"
        fi
        PS1=$PS1"[\u]"

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
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -a -l'
alias ..='cd ..'
alias cd..='cd ..'
alias vi='vim'
alias top='htop'
alias lt='tty-clock -s -r; vlock'
alias fuck='echo "sudo $(history -p !!)" && echo "press any key to continue" && read toto && sudo "$BASH" -c "$(history -p !!)" && history -s "sudo $(history -p !!)"'
alias damn='yes | "$BASH" -c "$(history -p !!)" &&  history -s "yes | $(history -p !!)"'

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

remind() {
    if [ "$#" == "0" ]; then
        echo -e "$PURPLE$(cat ~/.reminder)$COLOR_OFF";
    else
        echo "$@" >> ~/.reminder;
    fi
}

prompt_tag_color() {
    if [ "$#" == "0" ]; then
        echo -ne "$TAG_COLOR--"
    else
        REGEX="\\033\[[0-9;]*\m"
        if [[ $1 =~ $REGEX ]]; then
            TAG_COLOR=$1
        else
            echo "$1: invalid argument. Must match $REGEX"
        fi
    fi
}

prompt_tag() {
    if [ "$#" == "0" ]; then
        echo $PROMPT_TAG
    else
        PROMPT_TAG=$@
    fi
}

# Specific to one computer.
#setBacklight() {
#    if [ "$#" == "0" ]; then
#        echo "need one argument"
#    else
#        k_lvl="/sys/class/leds/samsung::kbd_backlight/brightness"
#        sudo chmod 666 $k_lvl
#        echo $1 > $k_lvl
#    fi
#}

ssh_tmux() {
    ssh -A -t "$1" tmux a || ssh -A -t "$1" tmux;
}

. ~/.local_bashrc
