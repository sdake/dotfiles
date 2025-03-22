###
#
# Fish Configuration
#
# Steven Dake <steven.dake@gmail.com>

if test (uname) = "Linux"
    set --export HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
else
    set --export HOMEBREW_PREFIX "/opt/homebrew"
end

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"
set --export TIME_STYLE "+%Y%m%d-%U-%H%M"

fish_add_path $HOMEBREW_PREFIX/bin
fish_add_path $HOMEBREW_PREFIX/sbin
fish_add_path $HOMEBREW_PREFIX/opt/curl/bin
fish_add_path $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
fish_add_path $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
fish_add_path $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
fish_add_path $HOMEBREW_PREFIX/opt/ncurses/bin
fish_add_path $HOMEBREW_PREFIX/opt/sqlite/bin

function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold red
      echo 'N'
    case insert
      set_color --bold green
      echo 'I'
    case replace_one
      set_color --bold green
      echo 'R'
    case visual
      set_color --bold brmagenta
      echo 'V'
    case '*'
      set_color --bold red
      echo '?'
  end
  set_color normal
end


if status is-interactive
    # Load all saved ssh keys
    ssh-add --apple-load-keychain ^/dev/null
    set --export --global LDFLAGS "-L${HOMEBREW_PREFIX}/glibc/lib"
    set --export --global CPPFLAGS "-I${HOMEBREW_PREFIX}/glibc/include"


    # I use Zen Browser, which is Firefox, that is reasonable to use. The
    # main advantage is to scale work vertically. Chrome scales work
    # horizontally.
    # To see configuration is Zen, run `fish_config` which will launch a new window 
    set --export BROWSER "/Applications/Zen Browser.app/"

    set --export STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    #    carapace _carapace fish | source
    source (starship init fish --print-full-init | psub)

    ###
    #
    # My environment overrides

    set --export LANG "en_US.UTF-8"
    set --export EDITOR nvim
    set --export GIT_EDITOR nvim
    set --export KUBE_EDITOR nvim
    set --export BUNDLER_EDITOR nvim
    set --export MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --language man'"
    #    set --export LS_COLORS "$(vivid generate rose-pine-moon)"

    set --export WEZTERM_LOG_FILE "$HOME/.config/logs/wezterm/wezterm.log"
    set --export WEZTERM_LOG_LEVEL DEBUG

    set --export FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore-vcs"
    set --export FZF_DEFAULT_OPTS "--height 75% --layout=reverse --border"
    set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set --export FZF_ALT_C_COMMAND "fd --type d . --color=never"

    set fish_greeting
    set fish_cursor_default block blink
    set fish_cursor_visual block blink
    set fish_cursor_default block blink
    set fish_cursor_insert block blink
    set fish_cursor_external block blink
    set fish_cursor_visual block blink
    fish_vi_key_bindings insert


    ###
    #
    # command aliases

    alias cat="bat"
    alias vi="$EDITOR"
    alias hex="hexyl"
    alias df="duf"
    alias du="dust"
    alias watch="viddy"

    alias rh04="ssh -p 24022 98.165.69.213"
    alias rh05="ssh -p 25022 98.165.69.213"
    alias rh06="ssh -p 26022 98.165.69.213"
    alias rh07="ssh -p 27022 98.165.69.213"
    alias rh10="ssh -p 10022 98.165.69.213"
    alias rh104="ssh -p 20422 98.165.69.213"
    alias rh105="ssh -p 10522 98.165.69.213"
    alias rh100="ssh -p 10022 98.165.69.213"
    alias rh106="ssh -p 10622 98.165.69.213"
    alias s6="ssh -p 10622 98.165.69.213"
    alias a6="ssh -p 10622 arnold@98.165.69.213"
end
fish_config theme choose "catpuccin-fish"
