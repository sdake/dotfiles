###
#
# Copyright (c) 2025 Steven Dake (steven.dake@gmail.com)

###
#
# Individual component configs

cp -aR bat $HOME/repos/dotfiles/config
cp -aR btop $HOME/repos/dotfiles/config
cp -aR fastfetch $HOME/repos/dotfiles/config
cp -aR ghostty $HOME/repos/dotfiles/config
cp -aR git $HOME/repos/dotfiles/config
cp -aR iterm2/AppSupport $HOME/repos/dotfiles/config/iterm2
cp -aR nvim $HOME/repos/dotfiles/config
cp -aR oh-my-posh $HOME/repos/dotfiles/config
cp -aR setup-osx $HOME/repos/dotfiles/config
cp -aR wezterm $HOME/repos/dotfiles/config

###
#
# Fish requires special care, as I currently store API keys here.
# TODO(sdake): Need to not store API keys.

cp -aR fish $HOME/repos/dotfiles/config/
rm -f $HOME/repos/dotfiles/config/fish/api-keys.fish

###
#
# Top level path

cp -aR copy-archive.sh $HOME/repos/dotfiles
cp -aR README.md $HOME/repos/dotfiles
