
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

case "$TERM" in
    rxvt-256color)
        TERM=rxvt-unicode
        ;;
esac
            #############
            # Set COLOR #
            #############

    # Reset
Color_Off='\e[0m'       # Text Reset

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

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
    # To truncate PWD if > 1/3 of screen

function truncate_pwd
{
  newPWD="${PWD/#$HOME/~}"
  local pwdmaxlen=$((${COLUMNS:-30}/3))
  if [ ${#newPWD} -gt $pwdmaxlen ]
  then
     newPWD="[...]${newPWD: -$pwdmaxlen}"
  fi
  nbFiles=$(ls -1 | wc -l | sed 's: ::g')
  sizeFiles=$(ls -lah | grep -m 1 total | sed 's/total //')
}


            #########
            # START #
            #########

if hash xrdb 2>/dev/null; then
    xrdb ~/.Xdefault
fi
#command fortune | cowsay -f tux
echo -e $PURPLE $(cat ~/.reminder)
export PATH=$PATH:~/script

#        VAR

EDITOR=/usr/bin/vim
BROWSER=chromium

        ################# PS1 #################
        #                                     #
        # ┌[demorose][19:27:23 doriath:~]-[1] #
        # └╼[pts/2]─┤                         #
        #                                     #
        #######################################

    # Retrive return value
PROMPT_COMMAND='RET=$?;truncate_pwd;'
RET_VALUE='$(echo $RET)' #Ret value not colorized - you can modify it.
RET_SMILEY='$(if [[ $RET = 0 ]]; then echo -ne "\[$GREEN\]●"; else echo -ne "\[$RED\]●"; fi;)'

    # If root: red, else: blue
if [[ $EUID -ne 0 ]]; then
    PS1="\[$BLUE\]┌[\u]"
else
    PS1="\[$RED\]┌[R]"
fi

PS1=$PS1"\[$GREEN\][\[$YELLOW\]\t "

    #If over ssh, then add ssh:// on hostname
if [ -n "$SSH_CLIENT" ]; then
    PS1=$PS1"\[$UCYAN\]ssh://\h\[$CYAN\]:\${newPWD}"
else
    PS1=$PS1"\[$UCYAN\]\h\[$CYAN\]:\${newPWD}"
fi

PS1=$PS1"\[$GREEN\]]-[\[$PURPLE\]\$(who | wc -l)\[$GREEN\]]"
PS1=$PS1" $RET_SMILEY"

    # If root: red, else: blue
if [[ $EUID -ne 0 ]]; then
    PS1=$PS1"\[$BLUE\] \n└╼"
else
    PS1=$PS1"\[$RED\] \n└╼"
fi
PS1=$PS1"[`temp=$(tty) ; echo ${temp:5}`]─┤"
    # Reset color for command output
trap 'echo -ne "$Color_Off"' DEBUG

            ###########
            # ALIASES #
            ###########

#     CONNECTIONS
alias ssh="ssh -A"
alias demoroot='ssh root@demorose.me'

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
        echo -e $PURPLE $(cat ~/.reminder);
    else
        echo "$@\n" >> ~/.reminder;
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
