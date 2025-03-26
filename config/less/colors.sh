# less color configuration
# Start bold mode
export LESS_TERMCAP_md="$(tput bold; tput setaf 4)"
# Start underline mode
export LESS_TERMCAP_us="$(tput smul; tput setaf 2)"
# End underline mode
export LESS_TERMCAP_ue="$(tput rmul; tput sgr0)"
# Start standout mode
export LESS_TERMCAP_so="$(tput smso; tput setaf 0; tput setab 3)"
# End standout mode
export LESS_TERMCAP_se="$(tput rmso; tput sgr0)"
# End all modes
export LESS_TERMCAP_me="$(tput sgr0)"
# Set less options
export LESS="-R"
