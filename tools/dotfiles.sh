#!/bin/bash
###
#
# Copyright (c) 2025 Steven Dake (steven.dake@gmail.com)
#
# This script manages config files between $HOME/.config and $HOME/repos/dotfiles/config
# using a distribution.toml file to specify which files to include.
###

set -e

CONFIG_DIR="$HOME/.config"
DOTFILES_REPO="$HOME/repos/dotfiles"
DOTFILES_CONFIG="$DOTFILES_REPO/config"
DISTRIBUTION_FILE="$DOTFILES_REPO/distribution.toml"
DOTIGNORE_FILE="$DOTFILES_REPO/.dotignore"

# Check if distribution.toml exists
if [ ! -f "$DISTRIBUTION_FILE" ]; then
    echo "Error: distribution.toml file not found at $DISTRIBUTION_FILE"
    exit 1
fi

# Create .dotignore file if it doesn't exist
if [ ! -f "$DOTIGNORE_FILE" ]; then
    echo "# .dotignore - Patterns to exclude from dotfiles tracking" > "$DOTIGNORE_FILE"
    echo "# Each line is a bash glob pattern relative to \$HOME/.config" >> "$DOTIGNORE_FILE"
    echo "#" >> "$DOTIGNORE_FILE"
    echo "# Glob syntax quick reference:" >> "$DOTIGNORE_FILE"
    echo "#   * - matches any string of characters" >> "$DOTIGNORE_FILE"
    echo "#   ? - matches any single character" >> "$DOTIGNORE_FILE"
    echo "#   [abc] - matches one character given in the bracket" >> "$DOTIGNORE_FILE"
    echo "#   ** - matches directories recursively" >> "$DOTIGNORE_FILE"
    echo "#" >> "$DOTIGNORE_FILE"
    echo "# Examples:" >> "$DOTIGNORE_FILE"
    echo "fish/conf.d/api-keys.fish    # Ignore specific file with sensitive data" >> "$DOTIGNORE_FILE"
    echo "# fish/conf.d/*.secret       # Ignore files with .secret extension in fish/conf.d" >> "$DOTIGNORE_FILE"
    echo "# nvim/lazy-lock.json        # Ignore lock files" >> "$DOTIGNORE_FILE"
    echo "# **/node_modules            # Ignore all node_modules directories" >> "$DOTIGNORE_FILE"
    echo "# gcloud/**                  # Ignore everything in gcloud" >> "$DOTIGNORE_FILE"
    echo "" >> "$DOTIGNORE_FILE"
fi

# Function to check if a path matches any pattern in .dotignore
is_ignored() {
    local path="$1"
    
    # Ensure the path is relative to CONFIG_DIR
    if [[ "$path" == "$CONFIG_DIR"/* ]]; then
        path="${path#$CONFIG_DIR/}"
    fi
    
    # Check each pattern in .dotignore
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        if [ -z "$line" ] || [[ "$line" == \#* ]]; then
            continue
        fi
        
        # Remove trailing comments from the line
        pattern=$(echo "$line" | sed 's/#.*$//' | xargs)
        
        # Check if path matches the pattern
        if [[ "$path" == $pattern ]] || [[ "$path" == */$pattern ]] || [[ "$path" == $pattern/* ]]; then
            return 0 # Path is ignored
        fi
    done < "$DOTIGNORE_FILE"
    
    return 1 # Path is not ignored
}

# Function to collect all files from the distribution.toml
get_distribution_files() {
    local files=()
    local current_section=""
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        if [ -z "$line" ] || [[ "$line" == \#* ]]; then
            continue
        fi

        # Check if this is a section header
        if [[ $line =~ \[(.*)\] ]]; then
            current_section="${BASH_REMATCH[1]}"
            continue
        fi

        # If line contains a file path (in the array)
        if [[ $line =~ \"([^\"]+)\" ]]; then
            file="${BASH_REMATCH[1]}"
            if [ -n "$current_section" ] && [ -n "$file" ]; then
                files+=("$current_section/$file")
            fi
        fi
    done < "$DISTRIBUTION_FILE"
    
    # Debug: Print all files found in distribution.toml
    #echo "DEBUG: Files found in distribution.toml:" >&2
    #for f in "${files[@]}"; do
    #    echo "  $f" >&2
    #done
    
    printf "%s\n" "${files[@]}"
}

# Command 1: Sync files from $HOME/.config to $HOME/repos/dotfiles/config
backup_to_repo() {
    echo "Syncing files from \$HOME/.config to \$HOME/repos/dotfiles/config..."
    
    # Get list of files from distribution.toml
    echo "Processing files listed in distribution.toml..."
    get_distribution_files | while read -r file_path; do
        local section=$(dirname "$file_path")
        local file=$(basename "$file_path")
        local source_dir="$CONFIG_DIR/$section"
        local target_dir="$DOTFILES_CONFIG/$section"
        local source_path="$source_dir/$file"
        local target_path="$target_dir/$file"
        
        # Check if file is in .dotignore
        if is_ignored "$source_path"; then
            echo "  Skipping ignored file: $section/$file"
            continue
        fi
        
        if [ -e "$source_path" ]; then
            echo "  Syncing $section/$file"
            mkdir -p "$(dirname "$target_path")"
            cp -aR "$source_path" "$target_path"
        else
            echo "  Warning: $source_path not found"
        fi
    done
    
    # Note: Sensitive files like api-keys.fish should be excluded via .dotignore
    
    echo "Sync completed to $DOTFILES_CONFIG"
}

# Command 2: Check status of files in distribution.toml
check_missing_files() {
    echo "Checking dotfiles status..."
    
    # Get all files tracked in distribution.toml
    mapfile -t tracked_files < <(get_distribution_files)
    
    # Store results for summary
    untracked_tools_count=0
    untracked_files_count=0
    missing_repo_count=0
    missing_config_count=0
    
    echo "" 
    echo "================== SUMMARY =================="
    
    # 1. Find all directories in $HOME/.config and check if they're in distribution.toml
    untracked_tools=0
    untracked_tools_list=""
    for dir in "$CONFIG_DIR"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            # Skip hidden directories
            if [[ "$dir_name" == .* ]]; then
                continue
            fi
            
            # Skip directories in .dotignore
            if is_ignored "$dir"; then
                continue
            fi
            
            # Check if this directory is in our distribution.toml
            if ! grep -q "\[$dir_name\]" "$DISTRIBUTION_FILE"; then
                if [ -z "$untracked_tools_list" ]; then
                    untracked_tools_list="$dir_name"
                else
                    untracked_tools_list="$untracked_tools_list, $dir_name"
                fi
                untracked_tools=1
                untracked_tools_count=$((untracked_tools_count + 1))
            fi
        fi
    done
    
    # Display summary of untracked tools
    if [ $untracked_tools -eq 0 ]; then
        echo "- All tools are tracked in distribution.toml"
    else
        echo "- Found $untracked_tools_count untracked tools"
    fi
    
    # 2. For directories that are in distribution.toml, check for untracked files
    # Group by tool (section)
    # Use declare with shopt to ensure associative arrays are supported
    untracked_by_tool=()
    
    for section in $(grep '\[.*\]' "$DISTRIBUTION_FILE" | sed 's/\[\(.*\)\]/\1/g'); do
        if [ -d "$CONFIG_DIR/$section" ]; then
            # Use find to list all files and process them directly
            find "$CONFIG_DIR/$section" -type f -not -path "*/\.*" | while read -r file; do
                # Remove the CONFIG_DIR prefix to get the relative path
                rel_path=${file#"$CONFIG_DIR/"}
                file_name=${file#"$CONFIG_DIR/$section/"}
                
                # Check if this file is in our tracked files
                found=0
                for tracked in "${tracked_files[@]}"; do
                    if [ "$tracked" = "$rel_path" ]; then
                        found=1
                        break
                    fi
                done
                
                if [ $found -eq 0 ]; then
                    # Skip files in .dotignore
                    if is_ignored "$file"; then
                        continue
                    fi
                    
                    # Store as section:files format in the array
                    untracked_by_tool+=("$section:\"$file_name\"")
                    untracked_files_count=$((untracked_files_count + 1))
                fi
            done
        fi
    done
    
    # Display summary of untracked files
    if [ ${#untracked_by_tool[@]} -eq 0 ]; then
        echo "- All files are tracked in distribution.toml"
    else
        echo "- Found $untracked_files_count untracked files"
    fi
    
    # 3. Check if tracked files exist in the dotfiles repo
    # Group by tool (section)
    missing_by_tool_repo=()
    
    for file_path in "${tracked_files[@]}"; do
        section=$(dirname "$file_path")
        file=$(basename "$file_path")
        repo_path="$DOTFILES_CONFIG/$section/$file"
        
        # Check if the file exists
        if [ ! -e "$repo_path" ]; then
            # Store as section:files format in the array
            missing_by_tool_repo+=("$section:\"$file\"")
            missing_repo_count=$((missing_repo_count + 1))
        fi
    done
    
    # Display summary of missing files in repo
    if [ ${#missing_by_tool_repo[@]} -eq 0 ]; then
        echo "- All tracked files are present in repo"
    else
        echo "- $missing_repo_count files need to be synced (missing in repo)"
    fi
    
    # 4. Check if tracked files exist in $HOME/.config
    # Group by tool (section)
    missing_by_tool_config=()
    
    for file_path in "${tracked_files[@]}"; do
        section=$(dirname "$file_path")
        file=$(basename "$file_path")
        config_path="$CONFIG_DIR/$section/$file"
        
        if [ ! -e "$config_path" ]; then
            # Store as section:files format in the array
            missing_by_tool_config+=("$section:\"$file\"")
            missing_config_count=$((missing_config_count + 1))
        fi
    done
    
    # Display summary of missing files in $HOME/.config
    if [ ${#missing_by_tool_config[@]} -eq 0 ]; then
        echo "- All tracked files are present in \$HOME/.config"
    else
        echo "- $missing_config_count files need to be installed (missing in \$HOME/.config)"
    fi
    
    echo "============================================="
    echo ""
    
    # Display detailed reports if there are items to report
    if [ $untracked_tools -ne 0 ]; then
        echo "=== Untracked tools (not in distribution.toml) ==="
        echo "  $untracked_tools_list"
        echo ""
    fi
    
    if [ ${#untracked_by_tool[@]} -ne 0 ]; then
        echo "=== Untracked files (not in distribution.toml) ==="
        # Print all entries organized by section
        current_section=""
        for entry in $(printf '%s\n' "${untracked_by_tool[@]}" | sort); do
            # Split by the first colon to get section and file
            section="${entry%%:*}"
            file="${entry#*:}"
            
            # If we've moved to a new section, print the section header
            if [ "$section" != "$current_section" ]; then
                # Only add a blank line if this isn't the first section
                if [ -n "$current_section" ]; then
                    echo ""
                fi
                echo "  Tool: $section"
                current_section="$section"
            fi
            
            echo "    File: $file"
        done
        echo ""
    fi
    
    if [ ${#missing_by_tool_repo[@]} -ne 0 ]; then
        echo "=== Files missing from repo (need to run 'sync') ==="
        # Print all entries organized by section
        current_section=""
        for entry in $(printf '%s\n' "${missing_by_tool_repo[@]}" | sort); do
            # Split by the first colon to get section and file
            section="${entry%%:*}"
            file="${entry#*:}"
            
            # If we've moved to a new section, print the section header
            if [ "$section" != "$current_section" ]; then
                # Only add a blank line if this isn't the first section
                if [ -n "$current_section" ]; then
                    echo ""
                fi
                echo "  Tool: $section"
                current_section="$section"
            fi
            
            echo "    File: $file"
        done
        echo ""
    fi
    
    if [ ${#missing_by_tool_config[@]} -ne 0 ]; then
        echo "=== Files missing from \$HOME/.config (need to run 'install') ==="
        # Print all entries organized by section
        current_section=""
        for entry in $(printf '%s\n' "${missing_by_tool_config[@]}" | sort); do
            # Split by the first colon to get section and file
            section="${entry%%:*}"
            file="${entry#*:}"
            
            # If we've moved to a new section, print the section header
            if [ "$section" != "$current_section" ]; then
                # Only add a blank line if this isn't the first section
                if [ -n "$current_section" ]; then
                    echo ""
                fi
                echo "  Tool: $section"
                current_section="$section"
            fi
            
            echo "    File: $file"
        done
        echo ""
    fi
    
    echo "Status check completed"
}

# Command 3: Install files from $HOME/repos/dotfiles/config to $HOME/.config
install_from_repo() {
    echo "Installing config files from \$HOME/repos/dotfiles/config to \$HOME/.config..."
    
    get_distribution_files | while read -r file_path; do
        local section=$(dirname "$file_path")
        local file=$(basename "$file_path")
        local source_path="$DOTFILES_CONFIG/$section/$file"
        local target_dir="$CONFIG_DIR/$section"
        local target_path="$target_dir/$file"
        
        if [ -e "$source_path" ]; then
            echo "  Installing $section/$file"
            mkdir -p "$(dirname "$target_path")"
            cp -aR "$source_path" "$target_path"
        else
            echo "  Warning: $source_path not found in repo"
        fi
    done
    
    echo "Installation completed to $CONFIG_DIR"
}

# Show usage if no arguments provided
usage() {
    echo "Usage: $0 <command> [options]"
    echo "Commands:"
    echo "  sync       - Sync files listed in distribution.toml from \$HOME/.config to \$HOME/repos/dotfiles/config"
    echo "  status     - Show status of files in distribution.toml"
    echo "  install    - Install files listed in distribution.toml from \$HOME/repos/dotfiles/config to \$HOME/.config"
    echo "  add <path> - Add a file or directory to distribution.toml"
    echo "  add-all    - Add all untracked files to distribution.toml"
    echo "  remove <path> - Remove a file or directory from distribution.toml (doesn't delete actual files)"
    echo "  wamense [-f|--force] - Clean up repository by removing files not tracked in distribution.toml"
    echo ""
    echo "Files matching patterns in \$HOME/repos/dotfiles/.dotignore will be skipped"
    exit 1
}


# Command 4: Add a file or directory to distribution.toml
do_track_files() {
    local section="$1"
    local files=("${@:2}")  # All arguments after the first one are files
    
    echo "Tracking files for section [$section]: ${files[*]}"
    
    # Read the entire distribution.toml file
    mapfile -t toml_lines < "$DISTRIBUTION_FILE"
    
    # Find the section's start and end (if it exists)
    section_start=-1
    section_end=-1
    for i in "${!toml_lines[@]}"; do
        if [[ "${toml_lines[$i]}" =~ ^\[$section\]$ ]]; then
            section_start=$i
        elif [[ $section_start -ne -1 && "${toml_lines[$i]}" =~ ^\[.*\]$ ]]; then
            section_end=$i
            break
        fi
    done
    
    # If section doesn't exist, add it at the end
    if [[ $section_start -eq -1 ]]; then
        echo "Creating new section [$section]"
        echo "" >> "$DISTRIBUTION_FILE"
        echo "# $section config files" >> "$DISTRIBUTION_FILE"
        echo "[$section]" >> "$DISTRIBUTION_FILE"
        echo "files = [" >> "$DISTRIBUTION_FILE"
        for file in "${files[@]}"; do
            echo "    \"$file\"," >> "$DISTRIBUTION_FILE"
        done
        echo "]" >> "$DISTRIBUTION_FILE"
        return 0
    fi
    
    # Create a temporary file for the reconstructed TOML
    tmpfile=$(mktemp)
    
    # Copy lines up to the section
    for ((i=0; i<section_start; i++)); do
        echo "${toml_lines[$i]}" >> "$tmpfile"
    done
    
    # Write section header
    echo "${toml_lines[$section_start]}" >> "$tmpfile"
    echo "files = [" >> "$tmpfile"
    
    # Write all files 
    for file in "${files[@]}"; do
        echo "    \"$file\"," >> "$tmpfile"
    done
    
    # Close the files array
    echo "]" >> "$tmpfile"
    
    # Skip to the next section in the original file
    if [[ $section_end -ne -1 ]]; then
        for ((i=section_end; i<${#toml_lines[@]}; i++)); do
            echo "${toml_lines[$i]}" >> "$tmpfile"
        done
    fi
    
    # Replace the original file
    mv "$tmpfile" "$DISTRIBUTION_FILE"
    echo "Section [$section] updated with new files"
}

track_file() {
    local path="$1"
    
    if [ -z "$path" ]; then
        echo "Error: No path provided to track"
        usage
        exit 1
    fi
    
    # Check if the path exists in $HOME/.config
    if [[ "$path" == /* ]]; then
        # Absolute path provided
        if [[ "$path" != "$CONFIG_DIR"/* ]]; then
            echo "Error: Path must be within \$HOME/.config"
            exit 1
        fi
        # Convert to relative path from $HOME/.config
        rel_path="${path#$CONFIG_DIR/}"
    else
        # Relative path provided, assume it's relative to $HOME/.config
        rel_path="$path"
        path="$CONFIG_DIR/$path"
    fi
    
    if [ ! -e "$path" ]; then
        echo "Error: Path '$path' does not exist"
        exit 1
    fi
    
    # Check if path is in .dotignore
    if is_ignored "$path"; then
        echo "Warning: Path '$path' is in .dotignore and won't be added"
        exit 0
    fi
    
    # Extract section (top-level directory) and file path
    if [[ "$rel_path" == */* ]]; then
        section=$(echo "$rel_path" | cut -d/ -f1)
        
        # For subdirectory files, just keep the path relative to $HOME/.config/section
        if [[ "$path" == "$CONFIG_DIR"/* ]]; then
            # Remove the CONFIG_DIR/section prefix to get actual file path in section
            file=${path#$CONFIG_DIR/$section/}
        else
            # For other paths, keep full relative path
            file=${rel_path#*/}
        fi
    else
        # For top-level files or directories
        section="$rel_path"
        file=""
    fi
    
    # Check if it's a directory
    if [ -d "$path" ] && [ -z "$file" ]; then
        echo "Adding section [$section] to distribution.toml"
        
        # Debug info
        echo "Searching for files in: $path"
        
        # List files before attempting to add them
        files_to_add=()
        echo "Files found in $path:"
        while IFS= read -r file_path; do
            echo "  $file_path"
            
            # Skip hidden files if needed
            if [[ $(basename "$file_path") == .* ]]; then
                echo "  Processing hidden file: ${file_path#$CONFIG_DIR/}"
            fi
            
            # Skip files in .dotignore
            if is_ignored "$file_path"; then
                echo "  Skipping ignored file: ${file_path#$CONFIG_DIR/}"
                continue
            fi
            
            # Get relative path from section directory
            rel_file_path=${file_path#$CONFIG_DIR/$section/}
            echo "  Will add: $rel_file_path"
            files_to_add+=("$rel_file_path")
        done < <(find "$path" -type f | sort)
        
        # Get existing files for this section
        existing_files=()
        
        while IFS= read -r line; do
            if [[ "$line" =~ \"([^\"]+)\" ]]; then
                existing_files+=("${BASH_REMATCH[1]}")
            fi
        done < <(grep -A 100 "^\[$section\]$" "$DISTRIBUTION_FILE" | grep -A 100 "^files = \[" | grep -B 100 "^]" | grep "\"")
        
        # Combine existing and new files
        all_files=("${existing_files[@]}" "${files_to_add[@]}")
        
        # Remove duplicate files
        unique_files=()
        for f in "${all_files[@]}"; do
            # Check if the file is already in unique_files
            already_added=0
            for uf in "${unique_files[@]}"; do
                if [[ "$f" == "$uf" ]]; then
                    already_added=1
                    break
                fi
            done
            
            # Add only unique files
            if [[ $already_added -eq 0 ]]; then
                unique_files+=("$f")
            fi
        done
        
        # Use the helper function to update the section
        do_track_files "$section" "${unique_files[@]}"
    else
        # It's a file
        echo "Adding file $file to section [$section]"
        
        # Get existing files for this section
        existing_files=()
        
        while IFS= read -r line; do
            if [[ "$line" =~ \"([^\"]+)\" ]]; then
                existing_files+=("${BASH_REMATCH[1]}")
            fi
        done < <(grep -A 100 "^\[$section\]$" "$DISTRIBUTION_FILE" | grep -A 100 "^files = \[" | grep -B 100 "^]" | grep "\"")
        
        # Check if file is already tracked
        already_tracked=0
        for existing in "${existing_files[@]}"; do
            if [[ "$existing" == "$file" ]]; then
                already_tracked=1
                break
            fi
        done
        
        if [[ $already_tracked -eq 1 ]]; then
            echo "File $file is already tracked in section [$section]"
        else
            # Add the file to existing files
            all_files=("${existing_files[@]}" "$file")
            
            # Update the section
            do_track_files "$section" "${all_files[@]}"
            echo "File $file added to section [$section]"
        fi
    fi
}

# Command 5: Add all untracked files from $HOME/.config to distribution.toml
add_all_untracked() {
    echo "Adding all untracked files to distribution.toml..."
    
    # Get all files tracked in distribution.toml
    mapfile -t tracked_files < <(get_distribution_files)
    
    # First add all untracked directories
    for dir in "$CONFIG_DIR"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            # Skip hidden directories
            if [[ "$dir_name" == .* ]]; then
                continue
            fi
            
            # Skip directories in .dotignore
            if is_ignored "$dir"; then
                echo "Skipping ignored directory: $dir_name"
                continue
            fi
            
            # Check if this directory is not in our distribution.toml
            if ! grep -q "\[$dir_name\]" "$DISTRIBUTION_FILE"; then
                echo "Tracking directory: $dir_name"
                track_file "$dir"
            fi
        fi
    done
    
    # Then find all untracked files in tracked directories
    for section in $(grep '\[.*\]' "$DISTRIBUTION_FILE" | sed 's/\[\(.*\)\]/\1/g'); do
        if [ -d "$CONFIG_DIR/$section" ]; then
            echo "Checking for untracked files in section: $section"
            
            # Get latest list of tracked files (may have changed)
            mapfile -t tracked_files < <(get_distribution_files)
            
            # Use find to list all files and process them directly
            find "$CONFIG_DIR/$section" -type f -not -path "*/\.*" | while read -r file; do
                # Remove the CONFIG_DIR prefix to get the relative path
                rel_path=${file#"$CONFIG_DIR/"}
                
                # Skip files in .dotignore
                if is_ignored "$file"; then
                    echo "Skipping ignored file: $rel_path"
                    continue
                fi
                
                # Check if this file is in our tracked files
                found=0
                for tracked in "${tracked_files[@]}"; do
                    if [ "$tracked" = "$rel_path" ]; then
                        found=1
                        break
                    fi
                done
                
                if [ $found -eq 0 ]; then
                    echo "Adding untracked file: $rel_path"
                    track_file "$file"
                fi
            done
        fi
    done
    
    echo "All untracked files have been added to distribution.toml"
}

# Command 6: Remove a file or directory from distribution.toml (does not delete actual files)
remove_file() {
    local path="$1"
    
    if [ -z "$path" ]; then
        echo "Error: No path provided to remove"
        usage
        exit 1
    fi
    
    # Check if the path format is valid
    if [[ "$path" == /* ]]; then
        # Absolute path provided
        if [[ "$path" == "$CONFIG_DIR"/* ]]; then
            # Path is in $HOME/.config
            rel_path="${path#$CONFIG_DIR/}"
            section=$(dirname "$rel_path")
            if [ "$section" = "." ]; then
                section=$(basename "$rel_path")
                file=""
            else
                file=$(basename "$rel_path")
            fi
        elif [[ "$path" == "$DOTFILES_CONFIG"/* ]]; then
            # Path is in $HOME/repos/dotfiles/config
            rel_path="${path#$DOTFILES_CONFIG/}"
            section=$(dirname "$rel_path")
            if [ "$section" = "." ]; then
                section=$(basename "$rel_path")
                file=""
            else
                file=$(basename "$rel_path")
            fi
        else
            echo "Error: Path must be within \$HOME/.config or \$HOME/repos/dotfiles/config"
            exit 1
        fi
    else
        # Relative path provided
        rel_path="$path"
        section=$(dirname "$rel_path")
        if [ "$section" = "." ]; then
            section=$(basename "$rel_path")
            file=""
        else
            file=$(basename "$rel_path")
        fi
    fi
    
    # Check if it's a directory removal (entire section)
    if [ -z "$file" ] || [ "$file" = "$section" ]; then
        echo "Removing entire section [$section] from distribution.toml"
        
        # Check if section exists
        if grep -q "^\[$section\]$" "$DISTRIBUTION_FILE"; then
            # Find start and end of section
            section_start=$(grep -n "^\[$section\]$" "$DISTRIBUTION_FILE" | cut -d: -f1)
            next_section=$(tail -n +$((section_start+1)) "$DISTRIBUTION_FILE" | grep -n "^\[.*\]$" | head -1 | cut -d: -f1)
            
            if [ -z "$next_section" ]; then
                # This is the last section, remove to end of file
                sed -i '' "${section_start},\$d" "$DISTRIBUTION_FILE"
            else
                # Remove this section up to the next section
                section_end=$((section_start + next_section - 1))
                sed -i '' "${section_start},${section_end}d" "$DISTRIBUTION_FILE"
            fi
            
            echo "Section [$section] removed from distribution.toml"
        else
            echo "Section [$section] not found in distribution.toml"
        fi
    else
        # It's a file removal
        echo "Removing file $file from section [$section]"
        
        # Check if section exists
        if grep -q "^\[$section\]$" "$DISTRIBUTION_FILE"; then
            # Check if file is tracked
            if grep -q "\"$file\"" "$DISTRIBUTION_FILE"; then
                # Remove the file line
                sed -i '' "/\"$file\"/d" "$DISTRIBUTION_FILE"
                echo "File $file removed from section [$section]"
                
                # Check if there are any files left in the section
                files_line=$(grep -n "^files = \[$" "$DISTRIBUTION_FILE" | grep -A1 "^\[$section\]$" | tail -1 | cut -d: -f1)
                close_array=$(tail -n +$files_line "$DISTRIBUTION_FILE" | grep -n "^]$" | head -1 | cut -d: -f1)
                close_line=$((files_line + close_array - 1))
                
                # If there are no files between "files = [" and "]", remove the section
                if [ $((close_line - files_line)) -eq 1 ]; then
                    echo "No files left in section [$section], removing section"
                    remove_file "$section"
                fi
            else
                echo "File $file not found in section [$section]"
            fi
        else
            echo "Section [$section] not found in distribution.toml"
        fi
    fi
}

# Wamense - Clean up untracked files in repo
wamense() {
    local force=0
    if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
        force=1
    fi
    
    echo "Cleaning up untracked files from repository..."
    
    # Get all tracked files
    mapfile -t tracked_files < <(get_distribution_files)
    
    # Convert tracked_files to full paths in the repo
    tracked_repo_files=()
    for file in "${tracked_files[@]}"; do
        tracked_repo_files+=("$DOTFILES_CONFIG/$file")
    done
    
    # Find all files in the dotfiles/config directory
    echo "Scanning repository for files..."
    all_repo_files=()
    while IFS= read -r -d '' file; do
        # Skip directories
        if [ -f "$file" ]; then
            all_repo_files+=("$file")
        fi
    done < <(find "$DOTFILES_CONFIG" -type f -print0)
    
    # Compare and remove files not in distribution.toml
    removed_count=0
    
    # In non-force mode, show files that will be removed
    if [ $force -eq 0 ]; then
        echo ""
        echo "The following files will be removed from the repository:"
        echo ""
        for repo_file in "${all_repo_files[@]}"; do
            # Check if file is tracked
            is_tracked=0
            for tracked_file in "${tracked_repo_files[@]}"; do
                if [ "$repo_file" = "$tracked_file" ]; then
                    is_tracked=1
                    break
                fi
            done
            
            # If not tracked, mark for removal
            if [ $is_tracked -eq 0 ]; then
                # Get relative path for display
                rel_path=${repo_file#$DOTFILES_CONFIG/}
                echo "  $rel_path"
                removed_count=$((removed_count + 1))
            fi
        done
        
        if [ $removed_count -eq 0 ]; then
            echo "No untracked files found in repository."
            return
        fi
        
        echo ""
        echo "Total files to remove: $removed_count"
        echo ""
        
        # Ask for confirmation
        read -p "Are you sure you want to remove these files? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            return
        fi
    fi
    
    # Remove untracked files
    removed_count=0
    for repo_file in "${all_repo_files[@]}"; do
        is_tracked=0
        for tracked_file in "${tracked_repo_files[@]}"; do
            if [ "$repo_file" = "$tracked_file" ]; then
                is_tracked=1
                break
            fi
        done
        
        if [ $is_tracked -eq 0 ]; then
            rel_path=${repo_file#$DOTFILES_CONFIG/}
            rm -f "$repo_file"
            if [ $force -eq 0 ]; then
                echo "Removed: $rel_path"
            fi
            removed_count=$((removed_count + 1))
        fi
    done
    
    # Clean up empty directories
    if [ $force -eq 0 ]; then
        echo "Cleaning up empty directories..."
    fi
    find "$DOTFILES_CONFIG" -type d -empty -delete
    
    if [ $force -eq 1 ]; then
        echo "Removed $removed_count untracked files from repository."
    else
        echo "Clean up completed."
    fi
}


# Main script
case "$1" in
    sync|save|backup)
        backup_to_repo
        ;;
    status|check)
        check_missing_files
        ;;
    install|apply)
        install_from_repo
        ;;
    add|track)
        track_file "$2"
        ;;
    add-all)
        add_all_untracked
        ;;
    remove|rm)
        remove_file "$2"
        ;;
    wamense)
        wamense "$2"
        ;;
    *)
        usage
        ;;
esac