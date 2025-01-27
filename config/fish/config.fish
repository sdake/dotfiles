###
#
# Fish Configuration
#
# Steven Dake <steven.dake@gmail.com>

set --export HOMEBREW_PREFIX /opt/homebrew
set --export HOMEBREW_CELLAR /opt/homebrew/Cellar
set --export HOMEBREW_REPOSITORY /opt/homebrew
set --export HOMEBREW_NO_ANALYTICS 1
set --export HOMEBREW_CASK_OPTS "--appdir=/Applications"
set --export TIME_STYLE "%Y%m%d-%U-%H%M"

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/curl/bin
fish_add_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
fish_add_path /opt/homebrew/opt/gnu-tar/libexec/gnubin
fish_add_path /opt/homebrew/opt/ncurses/bin
fish_add_path /opt/homebrew/opt/sqlite/bin


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
    # oh-my-posh completion fish | source

    carapace _carapace fish | source
    oh-my-posh init fish --config "$HOME/.config/oh-my-posh/config.toml" | source

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

    # set --export WEZTERM_LOG_FILE "$HOME/.logs/wezterm/wezterm.log"
    # set --export WEZTERM_LOG_LEVEL DEBUG

    set --export FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore-vcs"
    set --export FZF_DEFAULT_OPTS "--height 75% --layout=reverse --border"
    set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set --export FZF_ALT_C_COMMAND "fd --type d . --color=never"

    # set --export HFTOKEN "your_api_key_here"
    # set --export OPENAI_API_KEY "your_api_key_here"
    # set --export ANTHROPIC_API_KEY "your_api_key_here"
    # set --export GOOGLE_API_KEY "your_api_key_here"
    # set --export KAGI_API_KEY "your_api_key_here"
    # set --export OPENAI_API_KEY="your_api_key_here"
    # set --export ANTHROPIC_API_KEY="your_api_key_here"
    # set --export AI21_API_KEY="your_api_key_here"
    # set --export COHERE_API_KEY="your_api_key_here"
    # set --export ALEPHALPHA_API_KEY="your_api_key_here"
    # set --export HUGGINFACEHUB_API_KEY="your_api_key_here"
    # set --export MISTRAL_API_KEY="your_api_key_here"
    # set --export REKA_API_KEY="your_api_key_here"
    # set --export TOGETHER_API_KEY="your_api_key_here"
    # set --export GROQ_API_KEY="your_api_key_here"
    # set --export DEEPSEEK_API_KEY="your_api_key_here"
    # set --export LLMS_DEFAULT_MODEL="gpt-3.5-turbo"

    set fish_greeting
    set fish_cursor_default block blink
    set fish_cursor_visual block blink


    fish_config theme choose "Rosé Pine"

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
