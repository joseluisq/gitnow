# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

set -g gitnow_xpaste

set -g gitnow_commands 'all' 'assume' 'bitbucket' 'bugfix' 'commit' 'feature' 'github' 'gitnow' 'hotfix' 'logs' 'merge' 'move' 'pull' 'push' 'release' 'show' 'stage' 'state' 'tag' 'unstage' 'untracked' 'upstream'

function __gitnow_read_config -d "Reads the GitNow config file"
    # Sets a clipboard program
    set gitnow_xpaste (__gitnow_get_clip_program)

    # Config file path used by default
    set -l config_file "$fish_snippets/.gitnow"

    # Download the default .gitnow file
    # Used as workaround for Fisher. see https://github.com/jorgebucaran/fisher/pull/573
    if not test -e $config_file
        curl -sSo $config_file https://raw.githubusercontent.com/joseluisq/gitnow/master/conf.d/.gitnow
    end

    # Prefer custom config file if it exists
    if test -e $GITNOW_CONFIG_FILE
        set config_file $GITNOW_CONFIG_FILE
    else if not test -e $config_file
        # Otherwise checks if default `.gitnow` file exists,
        # if doesn't then skip out file parsing
        return
    end

    # Parse `.gitnow` file content

    # 2 = keybindings
    # 3 = options
    set -l v_section 0

    # Valid sections
    set -l v_keybindings "keybindings"
    set -l v_options "options"

    # Options set 
    set -l v_clipboard 0

    # Loop every line
    while read -la l
        set -l v_str ""
        set -l v_comment 0
        set -l v_command_sep 0
        set -l v_command_key ""
        set -l v_command_val ""

        # Loop every char for current line
        echo $l | while read -n 1 -la c;
            switch $c
                case '['
                    if test $v_comment -eq 1; continue; end

                    # if test $v_section -gt 0
                    #     set v_section 0
                    #     continue
                    # end

                    # Start section
                    if test $v_section -eq 0; set v_section 1; end
                case ']'
                    if test $v_comment -eq 1; continue; end

                    # Check section name
                    if test $v_section -eq 1
                        # options
                        if [ "$v_str" = "$v_options" ]
                            set v_section 3
                            continue
                        end
                        
                        # keybindings
                        if [ "$v_str" = "$v_keybindings" ]
                            set v_section 2
                            continue
                        end
                    end

                    set v_section 0
                case ' '
                case '\n'
                case '\t'
                case '\r'
                    continue
                case '#'
                    if test $v_comment -eq 0; set v_comment 1; end
                    continue
                case '*'
                    if test $v_comment -eq 1; continue; end

                    # If section has started then accumulate chars and continue
                    if test $v_section -eq 1
                        set v_str "$v_str$c"
                        continue
                    end

                    # A [ abcde ] section is found so proceed with chars handling 
                    # NOTE: only alphabetic and hyphens chars are allowed
                    if test $v_section -eq 2; or test $v_section -eq 3
                        switch $c
                            case 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' '-'
                                if test $v_command_sep -eq 0
                                    set v_command_key "$v_command_key$c"
                                    continue
                                end

                                if test $v_command_sep -eq 2
                                    set v_command_val "$v_command_val$c"
                                    continue
                                end
                            case \\
                                if test $v_command_sep -eq 1
                                    set v_command_sep 2
                                end
                                continue
                            case '='
                                set v_command_sep 1
                                if test $v_section -eq 3
                                    set v_command_sep 2
                                    continue
                                end
                            case '*'
                                continue
                        end
                    end
            end
        end

        # 1. Handle options set
        if test $v_section -eq 3
            switch $v_command_key
                # Clipboard option
                case 'clipboard'
                    if [ "$v_command_val" = "true" ]
                        set v_clipboard 1
                    end
                # NOTE: handle future new options using a new case
                case '*'
                    continue
            end
            # continue loop after current option processed
            set v_section 0
            continue
        end

        # 2. Handle keybindings set
        if not [ "$v_command_key" = "" ]; and not [ "$v_command_val" = "" ]
            set -l cmd

            switch $v_command_key
                case 'release' 'hotfix' 'feature' 'bugfix'
                    # Read text from clipboard if there is a valid clipboard program
                    # and if the "clipboard" option is "true"
                    if test -n $gitnow_xpaste; and test $v_clipboard -eq 1
                        set cmd (echo -n "bind \\$v_command_val \"echo; if $v_command_key ($gitnow_xpaste); commandline -f repaint; else ; end\"")
                    else
                        # Otherwise read text from standard input
                        set cmd (echo -n "bind \\$v_command_val \"echo; if $v_command_key (read); commandline -f repaint; else ; end\"")
                    end
                case '*'
                    # Check command key against a list of valid commands
                    set -l v_valid 0
                    for v in $gitnow_commands
                        if [ "$v" = "$v_command_key" ]
                            set v_valid 1
                            break
                        end
                    end

                    # If command key is not valid then just skip out
                    if test $v_valid -eq 0; continue; end

                    set cmd (echo -n "bind \\$v_command_val \"echo; $v_command_key; commandline -f repaint;\"")
            end

            eval $cmd
        end

    end < $config_file
end

function __gitnow_get_clip_program -d "Gets the current clip installed program"
    set -l v_paste

    if type -q xclip
        set v_paste "xclip -selection clipboard -o"
    else if type -q wl-clipboard
        set v_paste "wl-paste"
    else if type -q xsel
        set v_paste "xsel --clipboard --output"
    else if type -q pbpaste
        set v_paste "pbpaste"
    end

    echo -n $v_paste
end
