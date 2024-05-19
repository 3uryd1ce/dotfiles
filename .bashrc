# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output. So make sure this doesn't display
# anything or bad things will happen!


# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive. Be done now!
	return
fi


# Put your fun stuff here.

# if tmux is installed and not inside a tmux session, then try to attach.
# if attachment fails, start a new session
if [ -z "${TMUX}" ] && command -v tmux > /dev/null 2>&1; then
		{ tmux attach || tmux; } > /dev/null 2>&1
fi

set -o vi

. "${XDG_CONFIG_HOME:="${HOME}/.config"}/shell/aliases"