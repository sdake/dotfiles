#!/usr/bin/env bash

# Function to print colored text
print_color() {
  local bg=$1
  local fg=$2
  local name=$3
  local hex=$4
  
  # ANSI escape codes for colors
  local bg_code=$bg
  local fg_code=$fg
  
  printf "\e[${bg_code}m\e[${fg_code}m %-20s \e[0m" "$name"
  printf "\e[${bg_code}m\e[${fg_code}m %-12s \e[0m" "$hex"
  printf "\e[${bg_code}m\e[${fg_code}m This is a test \e[0m\n"
}

echo "=== Standard ANSI Colors ==="
echo "Format: Name | Code | Sample Text"
echo ""

# Basic colors (foreground)
echo "--- Foreground Colors ---"
print_color "49" "30" "Black" "30"
print_color "49" "31" "Red" "31"
print_color "49" "32" "Green" "32"
print_color "49" "33" "Yellow" "33"
print_color "49" "34" "Blue" "34"
print_color "49" "35" "Magenta" "35"
print_color "49" "36" "Cyan" "36"
print_color "49" "37" "White" "37"

echo ""
echo "--- Foreground Bright Colors ---"
print_color "49" "90" "Bright Black" "90"
print_color "49" "91" "Bright Red" "91"
print_color "49" "92" "Bright Green" "92"
print_color "49" "93" "Bright Yellow" "93"
print_color "49" "94" "Bright Blue" "94"
print_color "49" "95" "Bright Magenta" "95"
print_color "49" "96" "Bright Cyan" "96"
print_color "49" "97" "Bright White" "97"

echo ""
echo "--- Background Colors ---"
print_color "40" "97" "Black BG" "40"
print_color "41" "97" "Red BG" "41"
print_color "42" "30" "Green BG" "42"
print_color "43" "30" "Yellow BG" "43"
print_color "44" "97" "Blue BG" "44"
print_color "45" "30" "Magenta BG" "45"
print_color "46" "30" "Cyan BG" "46"
print_color "47" "30" "White BG" "47"

echo ""
echo "--- Background Bright Colors ---"
print_color "100" "97" "Bright Black BG" "100"
print_color "101" "30" "Bright Red BG" "101"
print_color "102" "30" "Bright Green BG" "102"
print_color "103" "30" "Bright Yellow BG" "103"
print_color "104" "97" "Bright Blue BG" "104"
print_color "105" "30" "Bright Magenta BG" "105"
print_color "106" "30" "Bright Cyan BG" "106"
print_color "107" "30" "Bright White BG" "107"

echo ""
echo "=== Color Combinations ==="
echo ""

# Test some specific combinations
print_color "44" "93" "Blue BG + Yellow FG" "44;93"
print_color "45" "96" "Magenta BG + Cyan FG" "45;96"
print_color "41" "97" "Red BG + White FG" "41;97"
print_color "42" "95" "Green BG + Magenta FG" "42;95"
print_color "100" "92" "Gray BG + Green FG" "100;92"
print_color "104" "93" "Bright Blue BG + Yellow FG" "104;93"

# Your custom selection colors from ghostty config
echo ""
echo "=== Your Custom Selection Colors ==="
echo "(approximated in ANSI - actual colors may vary)"
print_color "43" "94" "Selection (approx)" "Orange BG + Blue FG"

echo ""
echo "To use these colors in ghostty:"
echo "- For standard ANSI colors, use color0 through color15"
echo "- For custom colors, use hex codes like selection-background = #D08770"``
