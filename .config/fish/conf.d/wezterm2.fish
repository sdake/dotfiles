# Check if all features are disabled
if test "$WEZTERM_SHELL_SKIP_ALL" = "1"
    return
end

# Check for interactive shell
if not status is-interactive
    return
end

switch "$TERM"
    case 'linux' 'dumb'
        # Avoid working with terminals that don't support OSC sequences
        return
end

# Define a function to set user variables using OSC 1337
function wezterm_set_user_var --description 'Set WezTerm User Var'
    set -l var_name $argv[1]
    set -l var_value $argv[2]
    if which base64 > /dev/null
        if test -z "$TMUX"
            printf "\033]1337;SetUserVar=%s=%s\007" "$var_name" (printf "%s" "$var_value" | base64 -w 0)
        else
            printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "$var_name" (printf "%s" "$var_value" | base64 -w 0)
        end
    end
end

# Define a function to report the current working directory using OSC 7
function wezterm_osc7 --description 'Send current working directory to WezTerm'
    if which wezterm > /dev/null
        wezterm set-working-directory 2> /dev/null
        and return 0
    end
    printf "\033]7;file://%s%s\033\\" (hostname) "$PWD"
end

# Function to handle semantic prompt pre-command
function wezterm_semantic_precmd --description 'Set WezTerm semantic prompt zones'
    if test "$__wezterm_semantic_precmd_executing" != "0"
        # Save PS1 and PS2, which are not applicable in fish
    end
    if test "$__wezterm_semantic_precmd_executing" != ""
        printf "\033]133;D;%s;aid=%d\007" (status last-exit-code) (hostname -i)
    end
    printf "\033]133;A;cl=m;aid=%d\007" (hostname -i)
    set __wezterm_semantic_precmd_executing 0
end

function wezterm_semantic_preexec --description 'Preexec for semantic zones'
    # Restore PS1/PS2 if set, not applicable in fish
    printf "\033]133;C;\007"
    set __wezterm_semantic_precmd_executing 1
end

# User variable functions
function wezterm_user_vars_precmd --description 'Set WezTerm user vars before command'
    wezterm_set_user_var "WEZTERM_PROG" ""
    wezterm_set_user_var "WEZTERM_USER" (whoami)
    
    if test -n "$TMUX"
        wezterm_set_user_var "WEZTERM_IN_TMUX" "1"
    else
        wezterm_set_user_var "WEZTERM_IN_TMUX" "0"
    end
    
    if set -q WEZTERM_HOSTNAME
        wezterm_set_user_var "WEZTERM_HOST" "$WEZTERM_HOSTNAME"
    else
        wezterm_set_user_var "WEZTERM_HOST" (hostname)
    end
end

function wezterm_user_vars_preexec --description 'Preexec for setting WezTerm program user variable'
    wezterm_set_user_var "WEZTERM_PROG" $argv
end

# Register hooks in Fish shell
if test -z "$WEZTERM_SHELL_SKIP_SEMANTIC_ZONES"
    function fish_prompt --description 'Custom fish prompt with WezTerm integration'
        wezterm_semantic_precmd
        wezterm_user_vars_precmd
        wezterm_osc7
        # Remember to output your actual prompt here, this is just a placeholder
        echo -n 'replaceme> '
    end

    function fish_preexec --on-event fish_preexec --description 'Custom fish preexec for WezTerm'
        wezterm_user_vars_preexec $argv
        wezterm_semantic_preexec
    end
end

true
