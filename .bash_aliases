alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias suenv="sudo -E -s"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias :q=exit
alias vin="vim -u NONE"
alias reset="clear && printf '\e[3J'"
alias tmux="tmux -u"
alias g="git"
alias kl="kubectl"
alias kn="kubectl-ns"
alias kx="kubectl-ctx"
alias tv="tmux capture-pane -Jp -S- | vim -c 'setlocal buftype=nofile' -"

# ls after cd
cd() {
	builtin cd "$@" && ls -lA
}

# new session and attach
tnew() {
	if [ -n "$TMUX" ]; then
		tmux switch-client -t $1 || tmux new-session -ds $1
		tmux switch-client -t $1
	else
		tmux attach-session -t $1 || tmux -u new -s $1
	fi
}
