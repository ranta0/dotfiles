#!/usr/bin/env bash
NOTES_DIR="$HOME/notes/"
NOTES_FILE_FORMAT="md"
EDITOR="nvim"

file_name=$1
selected=$(find $NOTES_DIR -type f | fzf --print-query --preview="cat {}" --preview-window=right:70%:wrap --query="$file_name")
path=($selected)

if [[ "$selected" == *"$NOTES_DIR"* ]]; then
    case ${#path[@]} in
        1)
            $EDITOR ${path[0]}
            ;;

        2)
            $EDITOR ${path[1]}
            ;;
    esac
    exit 0
fi

if [[ $selected != '' ]]; then
    $EDITOR $NOTES_DIR"$selected".$NOTES_FILE_FORMAT
    exit 0
fi
