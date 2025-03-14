function f
    if test (count $argv) -eq 0
        echo "Usage: f <filename>"
        return 1
    end
    fd --hidden "^$argv[1]"
end
