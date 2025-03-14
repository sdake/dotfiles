###
#
# Copyright (c) 2025 Steven Dake (steven.dake@gmail.com)

###
#
# Individual component configs

cp -aR $HOME/.config/bat $HOME/repos/dotfiles/config
cp -aR $HOME/.config/btop $HOME/repos/dotfiles/config
cp -aR $HOME/.config/fastfetch $HOME/repos/dotfiles/config
cp -aR $HOME/.config/ghostty $HOME/repos/dotfiles/config
cp -aR $HOME/.config/git $HOME/repos/dotfiles/config
cp -aR $HOME/.config/iterm2/AppSupport $HOME/repos/dotfiles/config/iterm2
cp -aR $HOME/.config/nvim $HOME/repos/dotfiles/config
cp -aR $HOME/.config/oh-my-posh $HOME/repos/dotfiles/config
cp -aR $HOME/.config/setup-osx $HOME/repos/dotfiles/config
cp -aR $HOME/.config/wezterm $HOME/repos/dotfiles/config

###
#
# Fish requires special care, as I currently store API keys here.
# TODO(sdake): Need to not store API keys.

cp -aR $HOME/.config/fish $HOME/repos/dotfiles/config/
rm -f $HOME/repos/dotfiles/config/fish/api-keys.fish

###
#
# Top level path

cp -aR $HOME/.config/copy-archive.sh $HOME/repos/dotfiles
cp -aR $HOME/.config/README.md $HOME/repos/dotfiles
