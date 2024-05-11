alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias suenv="sudo -E -s"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias :q=exit
alias reset="clear && printf '\e[3J'"
alias tmux="tmux -u"
alias g="git"
alias kl="kubectl"
alias kn="kubectl-ns"
alias kx="kubectl-ctx"

# ls after cd
cd() {
	builtin cd "$@" && ls -lA
}

# new session
tnew() {
	tmux -u new -s "$1"
}
