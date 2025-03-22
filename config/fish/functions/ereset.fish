function ereset
    printf '\033c'           # Full reset
    printf '\033]104\007'    # Color reset
    printf '\033[!p'         # Soft reset
    printf '\033[?3;4l'      # Mode reset
    printf '\033[4l'         # Exit insert mode
    printf '\033[>'          # Exit keypad mode
end
