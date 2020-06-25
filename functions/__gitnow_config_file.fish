# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

set -g gitnow_xpaste

function __gitnow_read_config -d "Reads a GitNow config file"
    # sets a clipboard program
    set gitnow_xpaste (__gitnow_get_clip_program)

    # config file definition by default
    set -l config_file "$fish_snippets/.gitnow"

    # default .gitnow file download used as workaround
    if not test -e $config_file
        curl -sSo $config_file https://raw.githubusercontent.com/joseluisq/gitnow/master/.gitnow
    end

    # otherwise prefer custom config file
    if test -e $GITNOW_CONFIG_FILE
        set config_file $GITNOW_CONFIG_FILE
    end

    # checks if .gitnow file exists
    if test -e $config_file
        # reads the .gitnow file line by line
        set -l has_keybindings false

        for line in (command cat $config_file)
            # comments: skip out comment lines
            if __gitnow_is_comment_line $line
                continue
            end

            # section: keybindings (START)
            if __gitnow_is_section_line $line "keybindings"
                set has_keybindings
                continue
            end

            # section: read keybinding line
            if test has_keybindings
                __gitnow_read_keybinding_line $line
            end

            # TODO: continue reading other sections
        end 
    end
end

function __gitnow_is_comment_line -d "Checks if one line is a comment" -a line
    echo -n $line | command grep -qE '^\#(.+)$'
end

function __gitnow_is_section_line -d "Checks if one line is a valid section" -a line -a section
    set -l regx (echo -n '^\[[[:space:]]?'$section'[[:space:]]?\]$')
    echo -n $line | command grep -qE $regx
end

function __gitnow_is_key_value_pair -d "Checks if one line is a valid key-value pair" -a line
    echo -n $line | command grep -qE '^[[:space:]]?[a-z]+([-][a-z]+)?[[:space:]]?\\=[[:space:]]?\\\\[a-zA-Z0-9].+[[:space:]]?$'
end

function __gitnow_is_keybinding -d "Checks if one line is a valid keybinding char" -a line
    echo -n $line | command grep -qE '^\\\\[a-zA-Z0-9]{1}[a-zA-Z0-9]?$'
end

function __gitnow_read_keybinding_line -d "Reads a keybinding line" -a line
    set -l pairs (echo -n $line | command sed 's/^ *//;s/ *$//')

    # skip out if line is not a valid keybinding
    if not __gitnow_is_key_value_pair $pairs
        return
    end

    # TODO: continue processing keybindings
    set -l values (echo -n $line | command tr '=' '\n' | command sed 's/^ *//;s/ *$//')
    set -l cmd $values[1]
    set -l seq $values[2]

    # skip out if key is not a valid command
    if not type --quiet "$cmd"
        return
    end

    # skip out if value is not a valid keybinding
    if not __gitnow_is_keybinding $seq
        return
    end

    # finally bind corresponding keybinding
    set -l execmd

    if echo -n $cmd | command grep -qE '^(release|hotfix|feature|bugfix)$'
        # Gitflow: `release`, `hotfix`, `feature`, `bugfix`
        # those commands depend on one clipboard program

        # skip out if there is no a valid clipboard program
        if not test -n $gitnow_xpaste; return; end;

        set execmd (echo -n "bind $seq \"echo; if $cmd ($gitnow_xpaste); commandline -f repaint; else ; end\"")
    else
        set execmd (echo -n "bind $seq \"echo; if $cmd; commandline -f repaint; else; end\"")
    end

    eval $execmd
end

function __gitnow_get_clip_program -d "Gets the current clip installed program"
    set -l cpaste

    if type -q xclip
        set cpaste "xclip -selection clipboard -o"
    else
        if type -q xsel
            set cpaste "xsel --clipboard --output"
        end
        if type -q pbpaste
            set cpaste "pbpaste"
        end
    end

    echo -n $cpaste
end
