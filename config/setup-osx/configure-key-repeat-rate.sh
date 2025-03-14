###
#
# Set the key repeat rate:
# - Normal minimum is 2 (30ms) and 15 (225ms).
# - This configuration is 1 (15ms) and 10 (150ms).
#
# Each integer is 15ms.

defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
