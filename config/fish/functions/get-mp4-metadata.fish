function get_mp4_metadata
    if test (count $argv) -ne 1
        echo "Usage: get_mp4_metadata <filename>"
        return 1
    end
    
    set -l file $argv[1]
    
    if not test -f $file
        echo "Error: File '$file' does not exist"
        return 1
    end
    
    echo "========== FFPROBE METADATA =========="
    ffprobe -v quiet -print_format json -show_format -show_streams $file
    
    echo -e "\n========== MEDIAINFO METADATA =========="
    mediainfo $file
    
    echo -e "\n========== EXIFTOOL METADATA =========="
    exiftool $file
    
    echo -e "\n========== MP4INFO METADATA =========="
    mp4info $file
    
    return 0
end
