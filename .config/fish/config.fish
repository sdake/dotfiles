# Configure Jump
status --is-interactive; and source (jump shell fish | psub)

# Load all saved ssh keys
/usr/bin/ssh-add --apple-load-keychain ^/dev/null

# Fish syntax highlighting
set -g fish_color_autosuggestion '555'  'brblack'
set -g fish_color_cancel -r
set -g fish_color_command --bold
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end brmagenta
set -g fish_color_error brred
set -g fish_color_escape 'bryellow'  '--bold'
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection brblue
set -g fish_color_search_match 'bryellow'  '--background=brblack'
set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

if status is-interactive

    source "${HOME}/conifg/iterm2/iterm2_shell_integration.fish"
    source "${HOME}/.local/google-cloud-sdk/path.fish.inc"
    zoxide init fish | source
    kubectl completion fish | source
    oh-my-posh init fish --config "$HOME/.config/oh-my-posh/config.yaml" | source
    #    starship init fish | source - I have a prefeerence  for oh-my-posh

    ###
    #
    # My environment overrides

    set --universal --export EDITOR nvim
    set --universal --export GIT_EDITOR nvim
    set --universal --export KUBE_EDITOR nvim
    set --universal --export BUNDLER_EDITOR nvim
    set --universal --export MANPAGER 'less -X'
    #    set --universal --export HOMEBREW_CASK_OPTS '--appdir=/Applications'


    set --universal fish_user_paths $HOME/.local/bin $fish_user_paths
    set --universal fish_user_paths $HOME/.cargo/bin $fish_user_paths
    set --universal fish_user_paths $HOME/.local/go/bin $fish_user_paths

    set --universal fish_user_paths /usr/local/bin $fish_user_paths
    
    set --export WEZTERM_LOG_FILE $HOME/.config/wezterm/wezterm.log
    set --export WEZTERM_LOG_LEVEL DEBUG

    set --universal --export FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'
    set --universal --export FZF_DEFAULT_OPTS '--height 75% --layout=reverse --border'
    set --universal --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set --universal --export FZF_ALT_C_COMMAND 'fd --type d . --color=never'

    fish_vi_key_bindings

    set --export STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    set --export HFTOKEN "Obtain key from here: "
    set --export OPENAI_API_KEY "Obftain key from here: "

    set fish_greeting

    fish_config theme choose "Rosé Pine"

    ###
    #
    # command aliases

    alias cat='bat'
    alias vi='nvim'
    alias ls='eza --color=always --long --icons=always --no-time'
    alias cd='z'
end
