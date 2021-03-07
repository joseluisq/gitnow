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

    set -l v_section 0
    set -l v_keybindings_str ""
    set -l v_keybindings "keybindings"

    while read -la l
        set -l v_comment 0
        set -l v_command_sep 0
        set -l v_command_key ""
        set -l v_command_val ""

        echo $l | while read -n 1 -la c;
            switch $c
                case '['
                    if test $v_comment -eq 1; continue; end

                    if test $v_section -gt 0
                        set v_section 0
                        continue
                    end

                    if test $v_section -eq 0; set v_section 1; end
                case ']'
                    if test $v_comment -eq 1; continue; end

                    if test $v_section -eq 1
                        if [ "$v_keybindings_str" = "$v_keybindings" ]
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

                    if test $v_section -eq 1
                        set v_keybindings_str "$v_keybindings_str$c"
                        continue
                    end

                    # A [keybindings] section was already found
                    # NOTE: only alphabetic chars and hyphens are supported
                    if test $v_section -eq 2
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
                            case '*'
                                continue
                        end
                    end
            end
        end

        if not [ "$v_command_key" = "" ]; and not [ "$v_command_val" = "" ]
            set -l cmd

            switch $v_command_key
                case 'release' 'hotfix' 'feature' 'bugfix'
                    # Skip out if there is no a valid clipboard program
                    if not test -n $gitnow_xpaste; continue; end

                    set cmd (echo -n "bind \\$v_command_val \"echo; if $v_command_key ($gitnow_xpaste); commandline -f repaint; else ; end\"")
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

                    set cmd (echo -n "bind \\$v_command_val \"echo; if $v_command_key; commandline -f repaint; else ; end\"")
            end

            eval $cmd
        end

    end < $config_file
end

function __gitnow_get_clip_program -d "Gets the current clip installed program"
    set -l v_paste

    if type -q xclip
        set v_paste "xclip -selection clipboard -o"
    else if type -q xsel
        set v_paste "xsel --clipboard --output"
    else if type -q pbpaste
        set v_paste "pbpaste"
    end

    echo -n $v_paste
end
