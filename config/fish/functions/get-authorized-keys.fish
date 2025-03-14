function get-authorized-keys
    curl https://github.com/"$(gid --user --name)".keys >$HOME/.ssh/authorized_keys
end
