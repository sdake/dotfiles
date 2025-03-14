# Create ed25519 ssh key

ssh-keygen -n sdake -t ed25519 -V -1d:+90d -vvv -C "20241218.sdake@steak-m16"
ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519
set --export SSH_AUTH_SOCK $(launchctl getenv SSH_AUTH_SOCK)

https://docs.github.com/en/authentication/connecting-to-github-with-ssh

[SSH Passwords](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases)
[Store SSH Key on Github]()


# References

https://apple.stackexchange.com/questions/48502/how-can-i-permanently-add-my-ssh-private-key-to-keychain-so-it-is-automatically``
