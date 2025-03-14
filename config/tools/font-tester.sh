#!/bin/bash
# Font Style Tester for Ghostty
# This script displays text in various font styles and colors

# ANSI escape sequences
RESET="\033[0m"
BOLD="\033[1m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"

# Display header
echo -e "\n===== Ghostty Font Style Test =====\n"
echo -e "Testing font styles with MonoLisa Static and current theme colors\n"

# Basic font styles
echo -e "== Basic Font Styles =="
echo -e "Regular text:           ${RESET}The quick brown fox jumps over the lazy dog"
echo -e "Bold text:              ${BOLD}The quick brown fox jumps over the lazy dog${RESET}"
echo -e "Italic text:            ${ITALIC}The quick brown fox jumps over the lazy dog${RESET}"
echo -e "Bold italic text:       ${BOLD}${ITALIC}The quick brown fox jumps over the lazy dog${RESET}"
echo -e "Underlined text:        ${UNDERLINE}The quick brown fox jumps over the lazy dog${RESET}"
echo -e "Bold underlined:        ${BOLD}${UNDERLINE}The quick brown fox jumps over the lazy dog${RESET}"
echo -e "Italic underlined:      ${ITALIC}${UNDERLINE}The quick brown fox jumps over the lazy dog${RESET}"
echo -e "Bold italic underlined: ${BOLD}${ITALIC}${UNDERLINE}The quick brown fox jumps over the lazy dog${RESET}"

# Font styles with different colors (using ANSI 16 colors)
echo -e "\n== Font Styles with Colors =="

# Black (color0) text in different styles
echo -e "Color0 (Black) regular:  \033[30mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color0 (Black) bold:     \033[1;30mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color0 (Black) italic:   \033[3;30mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color0 (Black) bold+ita: \033[1;3;30mThe quick brown fox jumps over the lazy dog${RESET}"

# Red (color1) text in different styles
echo -e "Color1 (Red) regular:    \033[31mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color1 (Red) bold:       \033[1;31mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color1 (Red) italic:     \033[3;31mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color1 (Red) bold+ita:   \033[1;3;31mThe quick brown fox jumps over the lazy dog${RESET}"

# Green (color2) text in different styles
echo -e "Color2 (Green) regular:  \033[32mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color2 (Green) bold:     \033[1;32mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color2 (Green) italic:   \033[3;32mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color2 (Green) bold+ita: \033[1;3;32mThe quick brown fox jumps over the lazy dog${RESET}"

# Blue (color4) text in different styles
echo -e "Color4 (Blue) regular:   \033[34mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color4 (Blue) bold:      \033[1;34mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color4 (Blue) italic:    \033[3;34mThe quick brown fox jumps over the lazy dog${RESET}"
echo -e "Color4 (Blue) bold+ita:  \033[1;3;34mThe quick brown fox jumps over the lazy dog${RESET}"

# Test special characters and ligatures
echo -e "\n== Ligatures and Special Characters Test =="
echo -e "Arrows:       --> <-- <-> => <= <="
echo -e "Comparisons:  == != === !== >= <="
echo -e "Operations:   ++ -- ** // /* */"
echo -e "Brackets:     (()) {{}} [[]] <[]>"
echo -e "Others:       :: ... |> <| && || ??"

# Create a colorful output to test font rendering
echo -e "\n== Rainbow Test =="
echo -e "\033[31mR\033[33ma\033[32mi\033[36mn\033[34mb\033[35mo\033[31mw \033[33mT\033[32me\033[36mx\033[34mt \033[35mT\033[31me\033[33ms\033[32mt\033[0m"
echo -e "\033[1;31mR\033[1;33ma\033[1;32mi\033[1;36mn\033[1;34mb\033[1;35mo\033[1;31mw \033[1;33mB\033[1;32mo\033[1;36ml\033[1;34md \033[1;35mT\033[1;31me\033[1;33ms\033[1;32mt\033[0m"
echo -e "\033[3;31mR\033[3;33ma\033[3;32mi\033[3;36mn\033[3;34mb\033[3;35mo\033[3;31mw \033[3;33mI\033[3;32mt\033[3;36ma\033[3;34ml\033[3;35mi\033[3;31mc \033[3;33mT\033[3;32me\033[3;36ms\033[3;34mt\033[0m"
echo -e "\033[1;3;31mR\033[1;3;33ma\033[1;3;32mi\033[1;3;36mn\033[1;3;34mb\033[1;3;35mo\033[1;3;31mw \033[1;3;33mB\033[1;3;32mo\033[1;3;36ml\033[1;3;34md \033[1;3;35mI\033[1;3;31mt\033[1;3;33ma\033[1;3;32ml\033[1;3;36mi\033[1;3;34mc\033[0m"

# Test background colors
echo -e "\n== Background Colors Test =="
echo -e "BG Color1: \033[41mText on Red Background\033[0m"
echo -e "BG Color2: \033[42mText on Green Background\033[0m"
echo -e "BG Color4: \033[44mText on Blue Background\033[0m"
echo -e "BG Color5: \033[45mText on Magenta Background\033[0m"

# Mixed styles
echo -e "Mixed:     \033[1;32;44mBold Green Text on Blue Background\033[0m"
echo -e "Mixed:     \033[3;33;45mItalic Yellow Text on Magenta Background\033[0m"
echo -e "Mixed:     \033[1;3;36;41mBold Italic Cyan Text on Red Background\033[0m"

# Numbers and code samples
echo -e "\n== Numbers and Code Samples =="
echo -e "Numbers: 0123456789"
echo -e "Code:    ${BOLD}function${RESET} ${ITALIC}testStyles${RESET}() { ${BOLD}return${RESET} ${ITALIC}true${RESET}; }"
echo -e "Mixed:   ${BOLD}${ITALIC}const${RESET} x = ${BOLD}42${RESET}; ${ITALIC}// This is a comment${RESET}"

# Selection test
echo -e "\n== Selection Test =="
echo -e "Select this text to see how selection colors look"
echo -e "${BOLD}Select this bold text to test selection with bold${RESET}"
echo -e "${ITALIC}Select this italic text to test selection with italic${RESET}"
echo -e "${BOLD}${ITALIC}Select this bold italic text to test selection with bold italic${RESET}"

echo -e "\n===== Test Complete =====\n"
