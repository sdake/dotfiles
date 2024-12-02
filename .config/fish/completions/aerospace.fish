function _aerospace_12
    set 1 $argv[1]
    aerospace list-apps --format '%{app-bundle-id}%{right-padding}%{tab}%{app-name}'
end

function _aerospace_45
    set 1 $argv[1]
    aerospace list-workspaces --monitor all --empty no
end

function _aerospace_4
    set 1 $argv[1]
    aerospace list-apps --format '%{app-pid}%{right-padding}%{tab}%{app-name}'
end

function _aerospace_49
    set 1 $argv[1]
    true
end

function _aerospace_34
    set 1 $argv[1]
    aerospace config --get mode --keys | xargs -I{} aerospace config --get mode.{}.binding --keys
end

function _aerospace_29
    set 1 $argv[1]
    aerospace config --major-keys
end

function _aerospace_38
    set 1 $argv[1]
    aerospace config --get mode --keys
end

function _aerospace_46
    set 1 $argv[1]
    aerospace list-monitors --format '%{monitor-id}%{right-padding}%{tab}%{monitor-name}'
end

function _aerospace_50
    set 1 $argv[1]
    aerospace list-windows --all --format '%{window-id}%{tab}%{app-name}%{right-padding} | %{window-title}'
end

function _aerospace_subword_cmd_0
    true
end

function _aerospace_subword_1
    set mode $argv[1]
    set word $argv[2]

    set --local literals "-" "+"

    set --local descriptions

    set --local literal_transitions
    set literal_transitions[1] "set inputs 1 2; set tos 2 2"

    set --local match_anything_transitions_from 1 2
    set --local match_anything_transitions_to 3 3

    set --local state 1
    set --local char_index 1
    set --local matched 0
    while true
        if test $char_index -gt (string length -- "$word")
            set matched 1
            break
        end

        set --local subword (string sub --start=$char_index -- "$word")

        if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
            set --local --erase inputs
            set --local --erase tos
            eval $literal_transitions[$state]

            set --local literal_matched 0
            for literal_id in (seq 1 (count $literals))
                set --local literal $literals[$literal_id]
                set --local literal_len (string length -- "$literal")
                set --local subword_slice (string sub --end=$literal_len -- "$subword")
                if test $subword_slice = $literal
                    set --local index (contains --index -- $literal_id $inputs)
                    set state $tos[$index]
                    set char_index (math $char_index + $literal_len)
                    set literal_matched 1
                    break
                end
            end
            if test $literal_matched -ne 0
                continue
            end
        end

        if set --query match_anything_transitions_from[$state] && test -n $match_anything_transitions_from[$state]
            set --local index (contains --index -- $state $match_anything_transitions_from)
            set state $match_anything_transitions_to[$index]
            set --local matched 1
            break
        end

        break
    end

    if test $mode = matches
        return (math 1 - $matched)
    end


    set --local unmatched_suffix (string sub --start=$char_index -- $word)

    set --local matched_prefix
    if test $char_index -eq 1
        set matched_prefix ""
    else
        set matched_prefix (string sub --end=(math $char_index - 1) -- "$word")
    end
    if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
        set --local --erase inputs
        set --local --erase tos
        eval $literal_transitions[$state]
        for literal_id in $inputs
            set --local unmatched_suffix_len (string length -- $unmatched_suffix)
            if test $unmatched_suffix_len -gt 0
                set --local literal $literals[$literal_id]
                set --local slice (string sub --end=$unmatched_suffix_len -- $literal)
                if test "$slice" != "$unmatched_suffix"
                    continue
                end
            end
            if test -n $descriptions[$literal_id]
                printf '%s%s\t%s\n' $matched_prefix $literals[$literal_id] $descriptions[$literal_id]
            else
                printf '%s%s\n' $matched_prefix $literals[$literal_id]
            end
        end
    end

    set command_states 1 2
    set command_ids 0 0
    if contains $state $command_states
        set --local index (contains --index $state $command_states)
        set --local function_id $command_ids[$index]
        set --local function_name _aerospace_subword_cmd_$function_id
        set --local --erase inputs
        set --local --erase tos
        $function_name "$matched_prefix" | while read --local line
            printf '%s%s\n' $matched_prefix $line
        end
    end

    return 0
end


function _aerospace
    set COMP_LINE (commandline --cut-at-cursor)

    set COMP_WORDS
    echo $COMP_LINE | read --tokenize --array COMP_WORDS
    if string match --quiet --regex '.*\s$' $COMP_LINE
        set COMP_CWORD (math (count $COMP_WORDS) + 1)
    else
        set COMP_CWORD (count $COMP_WORDS)
    end

    set --local literals "move-mouse" "--count" "-v" "smart" "macos-native-fullscreen" "height" "toggle" "all-monitors-outer-frame" "h_accordion" "all" "--window-id" "monitor-force-center" "list-apps" "flatten-workspace-tree" "mode" "width" "summon-workspace" "focus-back-and-forth" "list-monitors" "h_tiles" "prev" "window-force-center" "trigger-binding" "move-node-to-workspace" "-h" "wrap-around-the-workspace" "enable" "--ignore-floating" "--visible" "close-all-windows-but-current" "--help" "--macos-native-hidden" "off" "move-workspace-to-monitor" "--boundaries" "workspace-back-and-forth" "--quit-if-last-window" "window-lazy-center" "workspace" "--major-keys" "accordion" "--focused" "tiling" "--app-bundle-id" "--mouse" "balance-sizes" "opposite" "on" "--auto-back-and-forth" "--version" "--json" "join-with" "reload-config" "--workspace" "floating" "--mode" "--boundaries-action" "resize" "visible" "close" "up" "layout" "--fail-if-noop" "list-exec-env-vars" "--monitor" "--focus-follows-window" "split" "--pid" "v_tiles" "monitor-lazy-center" "--keys" "wrap-around-all-monitors" "--wrap-around" "horizontal" "config" "--no-outer-gaps" "focused" "--all-keys" "--all" "left" "right" "--config-path" "--get" "--empty" "tiles" "--no-gui" "--format" "--dry-run" "move-node-to-monitor" "move" "focus" "down" "list-workspaces" "no" "stop" "debug-windows" "macos-native-minimize" "list-windows" "mouse" "next" "--dfs-index" "fullscreen" "focus-monitor" "v_accordion" "vertical"

    set --local descriptions

    set --local literal_transitions
    set literal_transitions[1] "set inputs 1 3 52 53 34 5 36 58 60 13 39 62 64 14 89 67 19 15 18 90 91 17 23 25 93 24 96 97 98 27 46 75 30 50 102 31 103; set tos 97 17 101 102 103 56 17 104 75 35 90 59 17 6 9 105 49 41 17 68 95 100 42 17 106 107 17 17 82 108 17 109 70 17 63 17 110"
    set literal_transitions[3] "set inputs 29 2 84 87 51; set tos 113 3 113 2 3"
    set literal_transitions[5] "set inputs 76 63 11 33 48; set tos 51 52 53 54 55"
    set literal_transitions[6] "set inputs 54; set tos 7"
    set literal_transitions[8] "set inputs 9 20 55 74 85 43 69 41 104 105; set tos 8 8 8 8 8 8 8 8 8 8"
    set literal_transitions[9] "set inputs 100 11 21 92 61 80 81 63 73 66; set tos 11 12 11 11 11 11 11 9 13 9"
    set literal_transitions[10] "set inputs 63 11 66; set tos 24 25 24"
    set literal_transitions[11] "set inputs 63 11 73 66; set tos 11 26 11 11"
    set literal_transitions[13] "set inputs 100 11 21 92 61 80 81 63 73 66; set tos 11 111 11 11 11 11 11 13 13 13"
    set literal_transitions[15] "set inputs 68 2 54 87 42 79 44 51 65; set tos 37 30 65 94 72 72 29 30 46"
    set literal_transitions[16] "set inputs 63; set tos 17"
    set literal_transitions[18] "set inputs 80 81 92 61; set tos 19 19 19 19"
    set literal_transitions[19] "set inputs 11; set tos 81"
    set literal_transitions[20] "set inputs 29 2 94 84 87 51 65; set tos 20 21 21 20 22 21 23"
    set literal_transitions[21] "set inputs 29 2 84 87 51 65; set tos 20 21 20 22 21 23"
    set literal_transitions[23] "set inputs 10 99 77; set tos 99 99 99"
    set literal_transitions[24] "set inputs 11 63 66; set tos 25 24 24"
    set literal_transitions[27] "set inputs 80 81 100 92 21 61; set tos 28 28 28 28 28 28"
    set literal_transitions[28] "set inputs 73; set tos 17"
    set literal_transitions[30] "set inputs 68 2 44 54 51 65 87; set tos 37 30 29 65 30 46 94"
    set literal_transitions[32] "set inputs 8 39; set tos 33 33"
    set literal_transitions[33] "set inputs 35 57 80 81 92 28 61; set tos 32 96 78 78 78 33 78"
    set literal_transitions[34] "set inputs 94 2 87 51 32; set tos 35 35 36 35 34"
    set literal_transitions[35] "set inputs 2 87 51 32; set tos 35 36 35 34"
    set literal_transitions[38] "set inputs 51 83 71; set tos 38 39 38"
    set literal_transitions[40] "set inputs 56; set tos 41"
    set literal_transitions[42] "set inputs 56; set tos 43"
    set literal_transitions[44] "set inputs 100 21 73 66; set tos 45 45 44 44"
    set literal_transitions[45] "set inputs 73 66; set tos 45 45"
    set literal_transitions[46] "set inputs 10 99 77; set tos 47 47 47"
    set literal_transitions[47] "set inputs 10 2 68 99 54 87 44 51 65 77; set tos 47 30 37 47 65 94 29 30 46 47"
    set literal_transitions[48] "set inputs 94 2 87 51 45 42; set tos 49 49 50 49 48 48"
    set literal_transitions[49] "set inputs 2 87 51 45 42; set tos 49 50 49 48 48"
    set literal_transitions[51] "set inputs 76 63 11 48; set tos 51 52 53 55"
    set literal_transitions[52] "set inputs 76 63 11 48; set tos 52 52 74 55"
    set literal_transitions[54] "set inputs 11 63; set tos 81 17"
    set literal_transitions[55] "set inputs 11 76 63; set tos 79 55 55"
    set literal_transitions[56] "set inputs 63 11 33 48; set tos 56 57 58 58"
    set literal_transitions[58] "set inputs 11 63; set tos 93 58"
    set literal_transitions[59] "set inputs 9 85 11 20 55 74 43 69 41 104 105; set tos 8 8 60 8 8 8 8 8 8 8 8"
    set literal_transitions[61] "set inputs 63 11 66; set tos 61 62 61"
    set literal_transitions[63] "set inputs 76 63 11 33 48; set tos 51 64 4 54 55"
    set literal_transitions[64] "set inputs 76 63 11 33 48; set tos 52 52 74 54 55"
    set literal_transitions[65] "set inputs 59 77; set tos 66 66"
    set literal_transitions[66] "set inputs 68 2 59 54 87 44 51 77 65; set tos 37 30 66 65 94 29 30 66 46"
    set literal_transitions[67] "set inputs 51 71; set tos 67 67"
    set literal_transitions[68] "set inputs 80 81 11 92 61; set tos 19 19 69 19 19"
    set literal_transitions[70] "set inputs 37; set tos 17"
    set literal_transitions[71] "set inputs 2 84 87 42 29 79 51 65; set tos 21 20 22 72 20 72 21 23"
    set literal_transitions[72] "set inputs 87 2 51; set tos 87 17 17"
    set literal_transitions[73] "set inputs 49 63; set tos 73 73"
    set literal_transitions[75] "set inputs 11 37; set tos 76 75"
    set literal_transitions[77] "set inputs 26 72 95; set tos 78 78 78"
    set literal_transitions[78] "set inputs 35 57 28; set tos 117 77 78"
    set literal_transitions[80] "set inputs 9 20 55 74 85 43 69 41 104 105; set tos 8 8 8 8 8 8 8 8 8 8"
    set literal_transitions[82] "set inputs 68 2 54 87 42 79 44 51 65; set tos 37 15 65 14 72 72 29 15 46"
    set literal_transitions[84] "set inputs 74 105 47; set tos 19 19 19"
    set literal_transitions[85] "set inputs 33 48; set tos 16 16"
    set literal_transitions[86] "set inputs 80 81 92 61; set tos 17 17 17 17"
    set literal_transitions[90] "set inputs 49 100 63 21 73; set tos 92 28 92 28 91"
    set literal_transitions[91] "set inputs 21 100; set tos 28 28"
    set literal_transitions[92] "set inputs 49 63; set tos 92 92"
    set literal_transitions[95] "set inputs 11 92 28 61 35 57 80 81 101; set tos 81 78 33 78 32 96 78 78 87"
    set literal_transitions[96] "set inputs 26 72 95; set tos 33 33 33"
    set literal_transitions[97] "set inputs 63 38 12 22 70; set tos 98 16 16 16 16"
    set literal_transitions[98] "set inputs 70 38 12 22; set tos 16 16 16 16"
    set literal_transitions[99] "set inputs 10 2 99 84 87 29 51 77; set tos 99 3 99 113 2 113 3 99"
    set literal_transitions[100] "set inputs 63; set tos 31"
    set literal_transitions[101] "set inputs 80 81 11 92 61; set tos 17 17 112 17 17"
    set literal_transitions[102] "set inputs 86 88; set tos 102 102"
    set literal_transitions[103] "set inputs 21 73 100; set tos 28 91 28"
    set literal_transitions[104] "set inputs 4 6 11 16; set tos 89 89 118 89"
    set literal_transitions[105] "set inputs 47 11 74 105; set tos 19 83 19 19"
    set literal_transitions[106] "set inputs 2 84 87 42 29 79 51 65; set tos 71 20 114 72 20 72 71 23"
    set literal_transitions[107] "set inputs 66 63 100 11 73 21; set tos 107 61 45 62 44 45"
    set literal_transitions[108] "set inputs 63 33 7 48; set tos 85 16 17 16"
    set literal_transitions[109] "set inputs 78 40 71 51 83 82; set tos 17 17 38 38 39 17"
    set literal_transitions[110] "set inputs 100 92 21 61 80 81 73; set tos 28 28 28 28 28 28 27"
    set literal_transitions[113] "set inputs 29 2 94 84 87 51; set tos 113 3 3 113 2 3"
    set literal_transitions[115] "set inputs 4 6 16; set tos 89 89 89"
    set literal_transitions[117] "set inputs 8 39; set tos 78 78"

    set --local match_anything_transitions_from 76 7 112 37 79 66 88 99 47 46 83 29 10 43 25 14 36 65 60 114 94 31 111 69 118 26 50 53 39 61 9 2 116 42 4 22 92 41 93 100 62 81 107 74 90 23 87 57 110 12
    set --local match_anything_transitions_to 75 17 86 30 55 66 17 99 47 47 84 30 10 88 24 15 35 66 80 71 30 16 13 18 115 11 49 51 67 24 10 3 116 40 5 21 73 17 58 16 61 17 24 52 73 99 17 56 116 9
    set subword_transitions[89] "set subword_ids 1; set tos 19"

    set --local state 1
    set --local word_index 2
    while test $word_index -lt $COMP_CWORD
        set --local -- word $COMP_WORDS[$word_index]

        if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
            set --local --erase inputs
            set --local --erase tos
            eval $literal_transitions[$state]

            if contains -- $word $literals
                set --local literal_matched 0
                for literal_id in (seq 1 (count $literals))
                    if test $literals[$literal_id] = $word
                        set --local index (contains --index -- $literal_id $inputs)
                        set state $tos[$index]
                        set word_index (math $word_index + 1)
                        set literal_matched 1
                        break
                    end
                end
                if test $literal_matched -ne 0
                    continue
                end
            end
        end

        if set --query subword_transitions[$state] && test -n $subword_transitions[$state]
            set --local --erase subword_ids
            set --local --erase tos
            eval $subword_transitions[$state]

            set --local subword_matched 0
            for subword_id in $subword_ids
                if _aerospace_subword_$subword_id matches "$word"
                    set subword_matched 1
                    set state $tos[$subword_id]
                    set word_index (math $word_index + 1)
                    break
                end
            end
            if test $subword_matched -ne 0
                continue
            end
        end

        if set --query match_anything_transitions_from[$state] && test -n $match_anything_transitions_from[$state]
            set --local index (contains --index -- $state $match_anything_transitions_from)
            set state $match_anything_transitions_to[$index]
            set word_index (math $word_index + 1)
            continue
        end

        return 1
    end

    if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
        set --local --erase inputs
        set --local --erase tos
        eval $literal_transitions[$state]
        for literal_id in $inputs
            if test -n $descriptions[$literal_id]
                printf '%s\t%s\n' $literals[$literal_id] $descriptions[$literal_id]
            else
                printf '%s\n' $literals[$literal_id]
            end
        end
    end


    if set --query subword_transitions[$state] && test -n $subword_transitions[$state]
        set --local --erase subword_ids
        set --local --erase tos
        eval $subword_transitions[$state]

        for subword_id in $subword_ids
            set --local function_name _aerospace_subword_$subword_id
            $function_name complete "$COMP_WORDS[$COMP_CWORD]"
        end
    end

    set command_states 76 7 46 93 83 112 26 50 53 100 62 29 39 81 61 107 9 37 10 43 25 14 36 74 2 116 90 65 60 23 87 79 66 57 88 99 114 94 31 111 69 42 47 4 118 22 92 41 110 12
    set command_ids 50 45 46 50 50 50 50 49 50 45 50 12 29 50 45 45 49 4 49 38 50 49 49 50 49 49 45 45 50 46 49 50 45 50 34 46 49 49 45 50 50 34 46 50 50 49 45 38 49 50
    if contains $state $command_states
        set --local index (contains --index $state $command_states)
        set --local function_id $command_ids[$index]
        set --local function_name _aerospace_$function_id
        set --local --erase inputs
        set --local --erase tos
        $function_name "$COMP_WORDS[$COMP_CWORD]"
    end

    return 0
end

complete --command aerospace --no-files --arguments "(_aerospace)"
