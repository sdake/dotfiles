#!/usr/bin/env bash
# Create ed25519 ssh key
# 
ssh-keygen -n ${USER} -t ed25519 -V -1d:+90d -vvv -C "20241218.${USER}@$(hostname)"
ssh-add --apple-use-keychain "${HOME}/.ssh/id_ed25519"
set --export SSH_AUTH_SOCK "$(launchctl getenv SSH_AUTH_SOCK)"
