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

# new session and attach
tnew() {
	if [ -n "$TMUX" ]; then
		tmux switch-client -t $1 || tmux new-session -ds $1
		tmux switch-client -t $1
	else
		tmux attach-session -t $1 || tmux -u new -s $1
	fi
}

# switch panes and sessions
tlsi() {
	if [ -n "$TMUX" ]; then
		tmux list-panes -aF "#{session_name}:#{window_index}.#{pane_index} #{b:pane_current_path} => #{pane_current_path}: #{pane_current_command}" |
			fzf --layout=reverse |
			awk -F ' ' '{print $1}' |
			xargs -I {} tmux switch-client -t {}
	else
		tmux attach-session -t $(tmux list-sessions -F "#{session_name}:#{window_index}.#{pane_index} #{b:pane_current_path} => #{pane_current_path}: #{pane_current_command}" |
			fzf --layout=reverse |
			awk -F ':' '{print $1}')
	fi
}
