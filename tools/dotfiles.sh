#!/usr/bin/env bash
#
# dotfiles.sh - Consolidated dotfiles management tool
# Manages configuration files between local system and git repository

set -e

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Status symbols
CHECK_MARK="✓"
CROSS_MARK="✗"
WARNING_MARK="⚠"
INFO_MARK="ℹ"
ARROW_MARK="→"

# Paths
REPO_DIR="$HOME/repos/dotfiles"
CONFIG_DIR="$HOME/.config"
DISTRIBUTION_FILE="$REPO_DIR/distribution.toml"
DOTIGNORE_FILE="$REPO_DIR/.dotignore"

# Command usage
usage() {
    echo -e "${BOLD}Usage:${NC} $(basename $0) <+command> [options]"
    echo
    echo "Commands:"
    echo "  +sync          - Sync files from \$HOME/.config to \$HOME/repos/dotfiles/config"
    echo "  +status        - Show status of files in distribution.toml"
    echo "  +install       - Install files from \$HOME/repos/dotfiles/config to \$HOME/.config"
    echo "  +add <path>    - Add a file or directory to distribution.toml"
    echo "  +remove <path> - Remove a file or directory from distribution.toml (doesn't delete actual files)"
    echo "  +debug         - Run diagnostic checks on distribution file"
    echo "  +help          - Show this help message"
    echo
    echo "Files matching patterns in \$HOME/repos/dotfiles/.dotignore will be skipped"
    echo
    exit 1
}

# Check if required paths exist
check_paths() {
    if [ ! -d "$REPO_DIR" ]; then
        echo -e "${RED}${CROSS_MARK} Repository directory not found: $REPO_DIR${NC}"
        exit 1
    fi

    if [ ! -f "$DISTRIBUTION_FILE" ]; then
        echo -e "${RED}${CROSS_MARK} Distribution file not found: $DISTRIBUTION_FILE${NC}"
        exit 1
    fi

    # Create config directory if it doesn't exist
    if [ ! -d "$CONFIG_DIR" ]; then
        echo -e "${YELLOW}${WARNING_MARK} Config directory not found, creating: $CONFIG_DIR${NC}"
        mkdir -p "$CONFIG_DIR"
    fi
}

# Create .dotignore file if it doesn't exist
create_dotignore() {
    if [ ! -f "$DOTIGNORE_FILE" ]; then
        echo -e "${YELLOW}${WARNING_MARK} Creating .dotignore file${NC}"
        cat > "$DOTIGNORE_FILE" << EOF
# Add files to ignore when syncing
# Each line is a glob pattern matched against the basename of files
*history
*_history
*id_rsa*
*authorized_keys*
*known_hosts*
*htop
*netrc
*oauth*
*robrc
*token*
*.cert
*.key
*.pem
*.crt
*credentials*
*client_secret*
EOF
    fi
}

parse_sections() {
    grep '^\[.*\]$' "$DISTRIBUTION_FILE" | sed 's/\[\(.*\)\]/\1/'
}

parse_files() {
    local section=$1
    local in_section=false
    local in_array=false
    
    # Check if section exists
    if ! grep -q "^\[$section\]$" "$DISTRIBUTION_FILE"; then
        return
    fi
    
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^# ]]; then
            continue
        fi
        
        # Check if we've entered our section
        if [[ "$line" == "[$section]" ]]; then
            in_section=true
            continue
        fi
        
        # Check if we've entered a new section
        if [[ "$line" =~ ^\[.*\]$ && "$in_section" == true ]]; then
            break
        fi
        
        # Process lines in our section
        if [[ "$in_section" == true ]]; then
            # Check if we hit the files array - handle all formats
            if [[ "$line" == "files = [" ]]; then
                # Standard multi-line array start
                in_array=true
                continue
            # Properly handle all single-line array formats with better spacing patterns
            elif [[ "$line" =~ ^files[[:space:]]*=[[:space:]]*\[\"([^\"]+)\".*\]$ ]]; then
                # Single-line array with double quotes, any whitespace: files = ["theme.sh"]
                filename="${BASH_REMATCH[1]}"
                echo "$filename"
                continue
            elif [[ "$line" =~ ^files[[:space:]]*=[[:space:]]*\[\'([^\']+)\'.*\]$ ]]; then
                # Single-line array with single quotes, any whitespace: files = ['theme.sh']
                filename="${BASH_REMATCH[1]}"
                echo "$filename" 
                continue
            fi
            
            # If in array, extract the filenames
            if [[ "$in_array" == true ]]; then
                # Check if array ends
                if [[ "$line" == "]" ]]; then
                    in_array=false
                    continue
                fi
                
                # Extract filename from quoted entry
                filename=$(echo "$line" | sed -E 's/^[ ]*"(.+)",?$/\1/')
                if [ -n "$filename" ]; then
                    echo "$filename"
                fi
            fi
        fi
    done < "$DISTRIBUTION_FILE"
}

process_files() {
    local section=$1
    local action=$2
    local source_dir="$REPO_DIR/config/$section"
    local dest_dir="$CONFIG_DIR/$section"
    
    echo -e "${BLUE}${INFO_MARK} Processing section: ${BOLD}$section${NC}"
    
    if [ ! -d "$dest_dir" ]; then
        echo -e "${YELLOW}${WARNING_MARK} Creating directory: $dest_dir${NC}"
        mkdir -p "$dest_dir"
    fi
    
    parse_files "$section" | while IFS= read -r file; do
        if [[ -z "$file" || "$file" =~ ^# ]]; then
            continue
        fi
        
        # For sync: local → repo, so source is local, dest is repo
        # For install: repo → local, so source is repo, dest is local
        local repo_file="$source_dir/$file"
        local local_file="$dest_dir/$file"
        
        case "$action" in
            "install")
                install_file "$repo_file" "$local_file" "$section/$file"
                ;;
            "sync")
                sync_file "$local_file" "$repo_file" "$section/$file"
                ;;
            "status")
                check_status "$repo_file" "$local_file" "$section/$file"
                ;;
        esac
    done
}

install_file() {
    local source=$1
    local dest=$2
    local display_path=$3
    
    if [ -f "$source" ]; then
        mkdir -p "$(dirname "$dest")"
        cp -f "$source" "$dest"
        echo -e "${GREEN}${CHECK_MARK} Installed to local: ${NC}$display_path"
    else
        echo -e "${YELLOW}${WARNING_MARK} Repo file not found: ${NC}$display_path"
    fi
}

sync_file() {
    local source=$1
    local dest=$2
    local display_path=$3
    
    if [ -f "$source" ]; then
        mkdir -p "$(dirname "$dest")"
        cp -f "$source" "$dest"
        echo -e "${GREEN}${CHECK_MARK} Synced to repo: ${NC}$display_path"
    else
        echo -e "${YELLOW}${WARNING_MARK} Local file not found: ${NC}$display_path"
    fi
}

check_status() {
    local source=$1
    local dest=$2
    local display_path=$3
    
    if [ ! -f "$source" ]; then
        echo -e "${RED}${CROSS_MARK} Missing in repo: ${NC}$display_path"
        return
    fi
    
    if [ ! -e "$dest" ]; then
        echo -e "${YELLOW}${WARNING_MARK} Not installed: ${NC}$display_path"
        return
    fi
    
    if diff -q "$source" "$dest" >/dev/null 2>&1; then
        echo -e "${GREEN}${CHECK_MARK} Identical: ${NC}$display_path"
    else
        echo -e "${PURPLE}${ARROW_MARK} Modified locally: ${NC}$display_path"
    fi
}

add_file() {
    local section=$1
    local file=$2
    
    local source_dir="$REPO_DIR/config/$section"
    local dest_dir="$CONFIG_DIR/$section"
    local source_file="$source_dir/$file"
    local dest_file="$dest_dir/$file"
    
    if [ ! -f "$dest_file" ]; then
        echo -e "${RED}${CROSS_MARK} File not found: $dest_file${NC}"
        exit 1
    fi
    
    if [ ! -d "$source_dir" ]; then
        mkdir -p "$source_dir"
    fi
    
    if ! grep -q "^\[$section\]$" "$DISTRIBUTION_FILE"; then
        echo -e "\n[$section]" >> "$DISTRIBUTION_FILE"
    fi
    
    # Add file to distribution file if not already present
    if ! grep -A 100 "^\[$section\]$" "$DISTRIBUTION_FILE" | grep -m 1 -B 100 "^\[.*\]$" | grep -q "^$file$"; then
        # Find the position to insert the new file
        local section_line=$(grep -n "^\[$section\]$" "$DISTRIBUTION_FILE" | cut -d: -f1)
        local next_section_line=$(tail -n +$((section_line+1)) "$DISTRIBUTION_FILE" | grep -n "^\[.*\]$" | head -1 | cut -d: -f1)
        
        if [ -z "$next_section_line" ]; then
            # This is the last section, append to the end
            echo "$file" >> "$DISTRIBUTION_FILE"
        else
            # Insert before the next section
            sed -i "" "$((section_line+next_section_line-1))i\\
$file" "$DISTRIBUTION_FILE"
        fi
    fi
    
    # Copy file to repo
    mkdir -p "$(dirname "$source_file")"
    cp -f "$dest_file" "$source_file"
    
    echo -e "${GREEN}${CHECK_MARK} Added to tracking: ${NC}$section/$file"
}

remove_file() {
    local section=$1
    local file=$2
    
    local source_file="$REPO_DIR/config/$section/$file"
    local dest_file="$CONFIG_DIR/$section/$file"
    
    if grep -q "^\[$section\]$" "$DISTRIBUTION_FILE"; then
        sed -i "" "/^\[$section\]$/,/^\[.*\]$/ { /^$file$/d; }" "$DISTRIBUTION_FILE"
        echo -e "${BLUE}${INFO_MARK} Removed from distribution file: ${NC}$section/$file"
    fi
    
    # Instruct user to remove the file manually
    if [ -f "$source_file" ]; then
        echo -e "${YELLOW}${WARNING_MARK} To complete removal, manually delete the file: ${NC}$source_file"
        echo -e "   ${CYAN}rm $source_file${NC}"
    fi
}

# Removed cleanup function

# Run debug checks on distribution file
debug_distribution() {
    echo -e "${BLUE}${INFO_MARK} Running diagnostic checks...${NC}"
    
    # Check if distribution file exists
    echo -e "${CYAN}Checking distribution file:${NC} $DISTRIBUTION_FILE"
    if [ -f "$DISTRIBUTION_FILE" ]; then
        echo -e "${GREEN}${CHECK_MARK} Distribution file exists${NC}"
        echo -e "${CYAN}File size:${NC} $(wc -c < "$DISTRIBUTION_FILE") bytes"
        echo -e "${CYAN}Line count:${NC} $(wc -l < "$DISTRIBUTION_FILE") lines"
    else
        echo -e "${RED}${CROSS_MARK} Distribution file not found${NC}"
        exit 1
    fi
    
    # List all sections
    echo -e "\n${CYAN}Detected sections:${NC}"
    local sections=$(parse_sections)
    local count=0
    while IFS= read -r section; do
        if [ -n "$section" ]; then
            echo -e "${GREEN}${CHECK_MARK} Section:${NC} $section"
            count=$((count+1))
        fi
    done <<< "$sections"
    echo -e "${CYAN}Total sections:${NC} $count"
    
    # Test parsing first section
    echo -e "\n${CYAN}Testing section parsing:${NC}"
    local first_section=$(parse_sections | head -1)
    if [ -n "$first_section" ]; then
        echo -e "${GREEN}${CHECK_MARK} First section:${NC} $first_section"
        echo -e "${CYAN}Files in section:${NC}"
        
        local section_files=$(parse_files "$first_section")
        local file_count=0
        while IFS= read -r file; do
            if [ -n "$file" ]; then
                echo -e "  - $file"
                file_count=$((file_count+1))
                
                # Test one file
                if [ $file_count -eq 1 ]; then
                    local test_file="$file"
                    local source_file="$REPO_DIR/config/$first_section/$test_file"
                    local dest_file="$CONFIG_DIR/$first_section/$test_file"
                    
                    echo -e "\n${CYAN}Testing file installation:${NC}"
                    echo -e "${CYAN}Source:${NC} $source_file"
                    echo -e "${CYAN}Destination:${NC} $dest_file"
                    
                    if [ -f "$source_file" ]; then
                        echo -e "${GREEN}${CHECK_MARK} Source file exists${NC}"
                    else
                        echo -e "${RED}${CROSS_MARK} Source file not found${NC}"
                    fi
                    
                    if [ -e "$dest_file" ]; then
                        if diff -q "$source_file" "$dest_file" >/dev/null 2>&1; then
                            echo -e "${GREEN}${CHECK_MARK} Destination file exists and is identical to source${NC}"
                        else
                            echo -e "${YELLOW}${WARNING_MARK} Destination file exists but differs from source${NC}"
                        fi
                    else
                        echo -e "${YELLOW}${WARNING_MARK} Destination file does not exist${NC}"
                    fi
                fi
            fi
        done <<< "$section_files"
        echo -e "${CYAN}Total files in section:${NC} $file_count"
    else
        echo -e "${RED}${CROSS_MARK} No sections found${NC}"
    fi
    
    echo -e "\n${GREEN}${CHECK_MARK} Diagnostic checks complete${NC}"
}

# Main function
main() {
    if [ $# -eq 0 ]; then
        usage
    fi
    
    check_paths
    create_dotignore
    
    # Check if first argument starts with '+'
    if [[ "$1" != +* ]]; then
        echo -e "${RED}${CROSS_MARK} Commands must start with '+', e.g., +sync, +install${NC}"
        usage
        exit 1
    fi
    
    # Remove the leading '+'
    cmd="${1#+}"
    
    case "$cmd" in
        "sync")
            echo -e "${BOLD}Syncing dotfiles...${NC}"
            for section in $(parse_sections); do
                process_files "$section" "sync"
            done
            ;;
        "status")
            echo -e "${BOLD}Checking dotfiles status...${NC}"
            for section in $(parse_sections); do
                process_files "$section" "status"
            done
            ;;
        "install")
            echo -e "${BOLD}Installing dotfiles...${NC}"
            for section in $(parse_sections); do
                process_files "$section" "install"
            done
            ;;
        "add")
            if [ $# -lt 3 ]; then
                echo -e "${RED}${CROSS_MARK} Usage: $(basename $0) +add <path>${NC}"
                exit 1
            fi
            add_file "$2" "$3"
            ;;
        "remove")
            if [ $# -lt 3 ]; then
                echo -e "${RED}${CROSS_MARK} Usage: $(basename $0) +remove <path>${NC}"
                exit 1
            fi
            remove_file "$2" "$3"
            ;;
        "debug")
            debug_distribution
            ;;
        "help")
            usage
            ;;
        *)
            echo -e "${RED}${CROSS_MARK} Unknown command: $1${NC}"
            usage
            ;;
    esac
}

# Run main function
main "$@"
