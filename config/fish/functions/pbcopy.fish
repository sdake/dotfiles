function pbcopy
    cat $argv | base64 -w0 | xargs -0 printf "\033]52;c;%s\a"
end
