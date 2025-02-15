###
#
# Fish Configuration
#
# Steven Dake <steven.dake@gmail.com>

set --export HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
set --export HOMEBREW_PREFIX "/opt/homebrew"

set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"
set --export TIME_STYLE "%Y%m%d-%U-%H%M"

fish_add_path $HOMEBREW_PREFIX/bin
fish_add_path $HOMEBREW_PREFIX/sbin
fish_add_path $HOMEBREW_PREFIX/opt/curl/bin
fish_add_path $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
fish_add_path $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
fish_add_path $HOMEBREW_PREFIX/opt/ncurses/bin
fish_add_path $HOMEBREW_PREFIX/opt/sqlite/bin

if status is-interactive
    # Load all saved ssh keys
    ssh-add --apple-load-keychain ^/dev/null

    # Uncomment to enforce the use of TERM="wezterm". An alternative would be TERM="xterm-256color"
    # set --export TERM "wezterm"
    # set --export TERM "xterm-256color"

    # I use Zen Browser, which is Firefox, that is reasonable to use. The
    # main advantage is to scale work vertically. Chrome scales work
    # horizontally.
    # To see configuration is Zen, run `fish_config` which will launch a new window 
    set --export BROWSER "/Applications/Zen Browser.app/"

    # source "/opt/homebrew/share/google-cloud-sdk/path.fish.inc"
    # kubectl completion fish | source
    oh-my-posh completion fish | source

    carapace _carapace fish | source
    oh-my-posh init fish --config "$HOME/.config/oh-my-posh/config.toml" | source
    # source (/opt/homebrew/bin/starship init fish --print-full-init | psub)

    ###
    #
    # My environment overrides

    set --export LANG "en_US.UTF-8"
    set --export EDITOR nvim
    set --export GIT_EDITOR nvim
    set --export KUBE_EDITOR nvim
    set --export BUNDLER_EDITOR nvim
    set --export MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --language man'"
    set --export LS_COLORS "$(vivid generate rose-pine-moon)"

    set --export WEZTERM_LOG_FILE "$HOME/.config/logs/wezterm/wezterm.log"
    set --export WEZTERM_LOG_LEVEL DEBUG

    set --export FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore-vcs"
    set --export FZF_DEFAULT_OPTS "--height 75% --layout=reverse --border"
    set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set --export FZF_ALT_C_COMMAND "fd --type d . --color=never"

    set fish_greeting
    set fish_cursor_default block blink
    set fish_cursor_visual block blink

    fish_config theme choose "rose-pine-moon"

    ###
    #
    # command aliases

    alias cat="bat"
    alias vi="$EDITOR"
    alias ls="eza --header --color=always --icons=always --time-style=+$TIME_STYLE"
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

    function fish_mode_prompt
        # Disable vi mode indicator
    end
end
