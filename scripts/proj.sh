#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find \
        ~ \
        ~/Documents \
        ~/Documents/js \
        ~/Documents/python/src \
        ~/Documents/go/personal \
        /var/www/html \
        ~/.config \
        -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

cd "$selected"
