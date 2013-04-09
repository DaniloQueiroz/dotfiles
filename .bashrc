# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|/usr/bin/tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#######################
## Personal Settings ##
#######################

# check for emails on local box
MAIL=/var/spool/mail/$(whoami)
MAILCHECK=30

# Go up directory tree X number of directories
function -() {
    COUNTER="$@";
    # default $COUNTER to 1 if it isn't already set
    if [[ -z $COUNTER ]]; then
        COUNTER=1
    fi
    # make sure $COUNTER is a number
    if [ $COUNTER -eq $COUNTER 2> /dev/null ]; then
        nwd=`pwd` # Set new working directory (nwd) to current directory
        # Loop $nwd up directory tree one at a time
        until [[ $COUNTER -lt 1 ]]; do
            nwd=`dirname $nwd`
            let COUNTER-=1
        done
        cd $nwd # change directories to the new working directory
    else
        # print usage and return error
        echo "usage: - [NUMBER]"
        return 1
    fi
}

# choose a dir to change using globstar
# you can use 'cd **/dir' and it will show the available options
function cd() {
    if [ $# -eq 0 ]; then
        builtin cd $HOME
    elif [ $# -gt 1 ]; then
        # echo print the options
        printf "\nChoose a dir\n"
        idx=0
        for result in $*; do
            let idx++
            printf " - [%s] %s\n" ${idx} ${result}
        done 
        # choose one
        printf "[1 .. %s]: " ${idx}   
        read num
        # change dir
        builtin cd ${!num}
        unset num idx
    else
        # change dir
        builtin cd "$1"
    fi
}

# override help function - it now shows if the command is an alias,
# tries the builtin help and finally calls the man
# you can use 'help cmd' always, independent of the cmd type
function help() {
    if [ $# -eq 1 ]; then
        ( alias $1 || builtin help $1 || man $1 || printf "Unable to find help/man page for '%s'\n" ) 2> /dev/null
    else
        builtin help
    fi
}
alias ?='help'

# Manage screens session using Byobu
export BYOBU_BACKEND=screen
function screen() {
    case $1 in
        'list')
            byobu -ls
            ;;
        'help')
            echo "Use 'screen list' to list current sessions;"
            echo "or 'screen <window_name>' to start a new session or connect to the existent one."
            echo "Use sscreen to call the original screen command"
            ;;
        *)
            
            BYOBU_PROFILE=${1:-personal}
            BYOBU_SESSION=$(byobu -ls | grep ${BYOBU_PROFILE} | awk '{ print $1 }')
            if [ -n ${BYOBU_SESSION:-''} ]; then
                byobu-select-session $BYOBU_SESSION
            else
                BYOBU_WINDOWS=${BYOBU_PROFILE} byobu -S ${BYOBU_PROFILE}
            fi
            ;;
    esac
}
alias sscreen=/usr/bin/screen

#####
# replaces the default command_not_found_handle
# this custom one check if the command is at local dir
# avoiding that './command' things;
# then try to fix the typo for the first command sugested by
# the ubuntu command_not_found_handle; and if no soluction is
# found, invokes the ubuntu default command_not_found_handle
#####
# rename original command_not_found_handle to ubuntu_command_not_found_handle
declare -F command_not_found_handle > /dev/null || return 1
eval "$(echo "ubuntu_command_not_found_handle()"; declare -f command_not_found_handle | /usr/bin/tail -n +2)"
# the new command_not_found_handle function
function command_not_found_handle() {
    orig_cmd=$1
    shift 
    if [ -x ${orig_cmd} ]; then
        command ./${orig_cmd} $*
        return $?
    else
        # try to resolve as an git command/alias
        $(git status &> /dev/null) && $(git help ${orig_cmd} &> /dev/null)
        if [ $? -eq 0 ]; then
            command git ${orig_cmd} $*
            return $?
        fi

        cmd=$(/usr/lib/command-not-found ${orig_cmd} 2>&1 | head -n2 | /usr/bin/tail -n1 | awk -F\' '{ print $2 }')
        if [ -n "${cmd}" ]; then
            hash ${cmd} 2>/dev/null
            if [ $? -eq 0 ]; then
                printf "correct '%s' to '%s' [n/Y]: " ${orig_cmd} ${cmd}
                read resp
                if [ -z "$resp" ] || [ ${resp,,} == 'y' ]; then
                   command ${cmd} $*
                   return $?
                fi
            fi
        fi
        return $(ubuntu_command_not_found_handle ${orig_cmd} $*)
    fi
}

# complete ssh based on previous ssh commands
complete -W "$(egrep '^ssh ' ~/.bash_history | sort | uniq | sed 's/^ ssh //')" ssh

# fix spelling errors on cd command
shopt -s cdspell

# make $'dir' act as $'cd dir'
shopt -s autocd

# enable the ** operator
shopt -s globstar

# enable auto complete for hosts 
shopt -s hostcomplete

# enable ctrl+s (history search forward) 
stty -ixon
# avoid audible bell
set bell-style none

# change shell tab/autocomplete
#bind 'TAB:menu-complete'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'

# flush history after each command // useful for multiple bash sessions
PROMPT_COMMAND="history -a; history -c; history -r;$PROMPT_COMMAND"

# Aliases
alias rm='rm -rv'
alias log='tail -f -n0'
alias ack='ack-grep'
alias c='clear'
alias h='history'
alias s='sed'
alias v='vim'
alias pp='python -mjson.tool'
alias py='python'
alias pyclean='pyclean -v . && find . -name *.pyc -delete'
alias ttail='/usr/bin/tail'
alias tail='colortail'
alias eclipse='$(find ~ -name eclipse.ini -exec dirname {} + -quit)/eclipse'

# (g)it function
alias gg='g gui'
function g(){ 
    if [ $# -eq 0 ]; then
        git-sh
    elif [ $1 = 'gui' ]; then
        gitg . & &>/dev/null
    else
        git $*
    fi
}

# Use vim as pager
if [ -f /usr/share/vim/vim73/macros/less.sh ]
then
    alias less=/usr/share/vim/vim73/macros/less.sh
    alias lless='/usr/bin/less -MQRSi'
fi

## loads resty
if [ -f ~/.resty.sh ]; then
    source ~/.resty.sh
fi

# better pgrep 
pgrep () {
    if [ $1 == "-a" ]; then
        params="aux"
        shift
    else
        params="ux"
    fi
    ps ${params} | grep -v grep | grep $1 | awk '{ s = $2" "$1" "; for (i = 11; i <= NF; i++) s = s $i " "; print s }'
}

# Add case-insensitive `killall` tab completion of running apps
_complete_running_processes ()
{
	local LC_ALL='C'
	local IFS=$'\n'
	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=()

	# do not attempt completion if we're specifying an option
	[[ "$cur" == -* ]] && return 0

	# Escape dots in paths for grep
	cur=${cur//\./\\\.}

	COMPREPLY=( $(ps axc | /usr/bin/tail -n +2 | awk '{ print $5 }' | sort -u | grep -v "^[\-\(]" | grep -i "^$cur") )
}
complete -o bashdefault -o default -o nospace -F _complete_running_processes killall

# Add case-insensitive `kill` tab completion of running apps
_complete_running_processes_pids ()
{
	local re
	local LC_ALL='C'
	local IFS=$'\n'
	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=()

	# do not attempt completion if we're specifying an option
	[[ "$cur" == -* ]] && return 0

	# Escape dots in paths for grep
	cur=${cur//\./\\\.}

	if [[ $cur != *[!0-9]* ]]; then
		# search by PID
		re="^$cur"
	else
		# search by process name
		re="^[0-9]+ # $cur[^$]"
	fi

	COMPREPLY=( $(ps uxc | /usr/bin/tail -n +2 | awk '{ print $2" # " $11 }' | sort -u | grep -v "^[\-\(]" | egrep -i "$re") )
}
complete -o bashdefault -o default -o nospace -F _complete_running_processes_pids kill

## gradle autocomplete
_gradle_complete()
{
    local cur tasks
     
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    tasks='clean compile dists javadoc jar test war eclipse check run dependencyUpdates'
    cur=`echo $cur | sed 's/\\\\//g'`
    COMPREPLY=($(compgen -W "${tasks}" ${cur} | sed 's/\\\\//g') )
}
complete -F _gradle_complete -o filenames gradle
export GRADLE_OPTS="-Dorg.gradle.daemon=true"
alias gradle-stop='gradle --stop'


# git prompt
function parse_git_dirty {
    [[ $(git status 2> /dev/null | /usr/bin/tail -n1) != "nothing to commit (working directory clean)" ]] && echo " *"
}
function get_commit_count() {
    git status 2> /dev/null | awk '/Your branch is ahead/ {print " |"$(NF-1)}'
}
function git_branch_name() {
    git branch 2>/dev/null | grep -e '^*' | sed -E "s/^\* (.+)$/(\1$(parse_git_dirty)$(get_commit_count))/"
}
function show_colored_git_branch_in_prompt() {
    PS1=${PS1:0:-3}"\[\033[31m\]\$(git_branch_name)\[\033[m\]$ "
}
show_colored_git_branch_in_prompt




