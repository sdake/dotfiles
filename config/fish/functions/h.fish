function h
    if test (count $argv) -eq 0
        echo "Usage: f <filename>"
        return 1
    end
    set --local return_path $PWD
    cd $HOME/dwhelper
    fd --hidden "^$argv[1]"
    cd $return_path
end
