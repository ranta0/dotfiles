alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias suenv="sudo -E -s"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias :q=exit
alias pj=". proj"
alias reset="clear && printf '\e[3J'"

# ls after cd
cd() {
    builtin cd "$@" && ls -lA
}
