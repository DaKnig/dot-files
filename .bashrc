# /etc/profile

# System wide environment and startup programs, for login setup
# Functions and aliases go in /etc/bashrc

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}


if [ -x /usr/bin/id ]; then
    if [ -z "$EUID" ]; then
        # ksh workaround
        EUID=`/usr/bin/id -u`
        UID=`/usr/bin/id -ru`
    fi
    USER="`/usr/bin/id -un`"
    LOGNAME=$USER
    MAIL="/var/spool/mail/$USER"
fi

# Path manipulation
if [ "$EUID" = "0" ]; then
    pathmunge /usr/sbin
    pathmunge /usr/local/sbin
else
    pathmunge /usr/local/sbin after
    pathmunge /usr/sbin after
fi

HOSTNAME=`/usr/bin/hostname 2>/dev/null`
HISTSIZE=1000
if [ "$HISTCONTROL" = "ignorespace" ] ; then
    export HISTCONTROL=ignoreboth
else
    export HISTCONTROL=ignoredups
fi

export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL

# By default, we want umask to get set. This sets it for login shell
# Current threshold for system reserved uid/gids is 200
# You could check uidgid reservation validity in
# /usr/share/doc/setup-*/uidgid file
if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
    umask 002
else
    umask 022
fi

for i in /etc/profile.d/*.sh /etc/profile.d/sh.local ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then 
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done

unset i
unset -f pathmunge

if [ -n "${BASH_VERSION-}" ] ; then
        if [ -f /etc/bashrc ] ; then
                # Bash login shells run only /etc/profile
                # Bash non-login shells run only /etc/bashrc
                # Check for double sourcing is done in /etc/bashrc.
                . /etc/bashrc
       fi
fi

PROMPT_COMMAND=precmd

precmd() {
	echo -n
}

preexec() {
  if [ "$BASH_COMMAND" == "precmd" ]; then
    COMMAND="${DIRSTACK[*]}"
  else
    COMMAND="$BASH_COMMAND"
  fi

  PRO_TITLE="\e]0;${HOSTNAME%%.*}: $COMMAND\a"
  echo -ne "$PRO_TITLE"
}

#~/scripts/swap_home_end.sh
alias gdb='gdb -q'
alias make='make -j'
alias rrr='rr record -n'
alias hexdump='hexdump --canonical'
alias xclip='xclip -selection clipboard'
export XDG_CONFIG_HOME=$HOME/.config
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/uxnroms/uxn/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export LESSHISTFILE=$XDG_CONFIG_HOME/lesshst
export WINEPREFIX=$XDG_CONFIG_HOME/wine
export GIT_EXTERNAL_DIFF=difft
#eval "$(thefuck --alias)"
