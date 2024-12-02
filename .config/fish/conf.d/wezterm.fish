# Wezterm Shell Integration for Fish
# Converts Bash/Zsh integration to Fish syntax

# Skip integration if disabled
if set -q WEZTERM_SHELL_SKIP_ALL
    return
end

# Function to emit an OSC 1337 sequence to set a user variable
function __wezterm_set_user_var
    if type -q base64
        if not set -q TMUX
            printf "\033]1337;SetUserVar=%s=%s\007" $argv[1] (echo -n $argv[2] | base64)
        else
            printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" $argv[1] (echo -n $argv[2] | base64)
        end
    end
end

# Function to emit an OSC 7 sequence for the current working directory
function __wezterm_osc7
    if type -q wezterm
        wezterm set-working-directory ^/dev/null
    else
        printf "\033]7;file://%s%s\033\\" (hostname) (pwd)
    end
end

# Semantic precmd and preexec hooks
set -g __wezterm_semantic_precmd_executing 0

function __wezterm_semantic_precmd --on-event fish_prompt
    if test $__wezterm_semantic_precmd_executing -ne 0
        # Mark up the prompt output
        printf "\033]133;A;cl=m;aid=%d\007" $fish_pid
    end
    set -g __wezterm_semantic_precmd_executing 0
end

function __wezterm_semantic_preexec --on-event fish_preexec
    # Restore the original prompt if modified
    printf "\033]133;C;\007"
    set -g __wezterm_semantic_precmd_executing 1
end

# Set Wezterm user variables in the prompt
function __wezterm_user_vars_precmd --on-event fish_prompt
    __wezterm_set_user_var "WEZTERM_PROG" ""
    __wezterm_set_user_var "WEZTERM_USER" (id -un)

    if set -q TMUX
        __wezterm_set_user_var "WEZTERM_IN_TMUX" "1"
    else
        __wezterm_set_user_var "WEZTERM_IN_TMUX" "0"
    end

    if not set -q WEZTERM_HOSTNAME
        if type -q hostname
            __wezterm_set_user_var "WEZTERM_HOST" (hostname)
        end
    else
        __wezterm_set_user_var "WEZTERM_HOST" $WEZTERM_HOSTNAME
    end
end

function __wezterm_user_vars_preexec --on-event fish_preexec
    __wezterm_set_user_var "WEZTERM_PROG" $argv[1]
end

# Register hooks
if not set -q WEZTERM_SHELL_SKIP_SEMANTIC_ZONES
    function __wezterm_register_semantic_hooks
        functions --erase __wezterm_semantic_precmd
        functions --erase __wezterm_semantic_preexec
        function __wezterm_semantic_precmd --on-event fish_prompt
        end
        function __wezterm_semantic_preexec --on-event fish_preexec
        end
    end
    __wezterm_register_semantic_hooks
end

if not set -q WEZTERM_SHELL_SKIP_USER_VARS
    function __wezterm_register_user_hooks
        functions --erase __wezterm_user_vars_precmd
        functions --erase __wezterm_user_vars_preexec
        function __wezterm_user_vars_precmd --on-event fish_prompt
        end
        function __wezterm_user_vars_preexec --on-event fish_preexec
        end
    end
    __wezterm_register_user_hooks
end

if not set -q WEZTERM_SHELL_SKIP_CWD
    function __wezterm_register_osc7
        functions --erase __wezterm_osc7
        function __wezterm_osc7 --on-event fish_prompt
        end
    end
    __wezterm_register_osc7
end

