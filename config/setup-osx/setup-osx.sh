#!/usr/bin/env zsh

# Setup
# -----

# Don't require sudo password for the current user. Don't copy this if you have
# the fear that it'll break your sudo and lock you out your own system.
cat <<-RUBY | sudo ruby
  no_password_definition = <<-DEF.gsub(/^[ ]{4}/, '')
    # Don't require password for the $USER user.
    $USER ALL=(ALL) NOPASSWD: ALL
  DEF

  open("/etc/sudoers", "a+") do |sudoers|
    break if sudoers.read.include?(no_password_definition)
    sudoers.write("\n#{no_password_definition}")
  end
RUBY

# Applications
# ------------

# Let lunchy help with the manage of launch applications.
which lunchy &> /dev/null || sudo gem install lunchy

# Install puppet, to eventually deprecate most of this script.
which puppet &> /dev/null || sudo gem install puppet

# Install Homebrew unless it is already available.
which brew &> /dev/null || {
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
}

# Keep Pow installed by default.
[ -e "$HOME/Library/Application Support/Pow" ] || { curl get.pow.cx | sh }

# ZSH is my favourite shell.
brew install zsh

# Try out direnv.
brew install direnv

# The fish shell looks quite interesting, I'm gonna try it out, while keeping
# the default one.
brew install fish

# The j shell function relies on autojump.
brew install autojump

# Git is essential to Homebrew, so have it installed right after it. While I
# don't use Mercurial, a lot of packages require it for HEAD installs.
brew install git mercurial

# Wget is handy too, so keep it around.
brew install wget

# Now, install the GNU core utilities (ls, rm, etc.). By default they are
# prefixed with `g` (gls, grm, etc.), but the zshrc adds their unprefixed
# versions to the $PATH.
brew install coreutils

# I like Vim, so have it installed by default. Build it with Lua support, so I
# can test some of the new plugins.
brew install lua
brew install macvim --override-system-vim --with-lua

# My terminal multiplexer of choice.
brew install tmux

# Connect tmux to the OSX clipboard. E.g. pbcopy will work insiude of tmux
# sessions.
brew install reattach-to-user-namespace

# Ctags generates an index (or tag) file of language objects found in source
# files that allows these items to be quickly and easily located.
brew install ctags

# The silver searcher is a great searching tool. Similiar to ack, but faster.
brew install ag

# ImageMagick is needed quite often for web development. Gifsicle is there to
# make gifify happy.
brew install imagemagick
brew install gifsicle

# Cask let you install Mac applications distributed as binaries.
brew tap phinze/homebrew-cask
brew install brew-cask

# I come from Linux. I miss most of my old applications. They require X.Org X
# Window System.
brew cask install xquartz

# I bought alfred for a plasibo based productivity increase. Have it installed
# by default. Also the the brew-cask caskroom to the applictaions search path,
# so brewed applications can be found.
brew cask install alfred
brew cask alfred link

# Install Google Chrome as it is my default browser of choice.
brew cask install google-chrome

# I don't really like the default Terminal.app. iTerm2 is better.
brew cask install iterm2

# Always have Vagrant around. I'm trying to integrate it more closely into my
# workflow.
brew cask install vagrant

# All my friends are on Skype, so it is a must have on every install.
brew cask install skype

# Settings
# --------

# Enable the menu bar transparency.
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool true

# Always have AirDrop enabled.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable trackpad tap to click for this user and for the login screen.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Don't show shadows around the captured windows.
defaults write com.apple.screencapture disable-shadow -bool true

# Check for software updates daily, not just once per week.
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable press-and-hold for keys in favor of key repeat.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a keyboard repeat rate of 2ms.
defaults write NSGlobalDomain KeyRepeat -float 0.02

# Disable the two-finge swipe that triggers back and forward in Chrome.
defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool false

# Display the battery charge in a percentage.
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Disable mouse (not trackpad) acceleration.
defaults write .GlobalPreferences com.apple.mouse.scaling -int -1

# Use all F1, F2, etc. keys as standard function keys.
defaults write com.apple.keyboard.fnState -boolean true

# Now kill the affected applications so they can be restarted.
for app in Dashboard Dock SystemUIServer ; do killall $app > /dev/null ; done

# Updates
# -------

# Running `brew update` will sync up the formulae, but won't upgrade the
# currently installed packages to their latest versions.
brew update && brew upgrade

# Diagnostics
# -----------

# Running `brew doctor` will show pretty useful diagnostics information about
# Homebrew's health. For example, if I ever forget to install the XCode command
# line tools, it will remind me.
brew doctor

