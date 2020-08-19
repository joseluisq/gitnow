source $__fish_data_dir/completions/git.fish

# Move command

complete -f -x -c move -a '(__fish_git_branches)'

complete -f -x -c move \
    -s h -l help \
    -d "Show information about the options for this command"

complete -f -x -c move \
    -s n -l no-apply-stash \
    -a '(__fish_git_branches)' \
    -d "Switch to a local branch but without applying current stash" 

complete -f -x -c move \
    -s u -l upstream \
    -a '(__fish_git_branches)' \
    -d "Fetch a remote branch and switch to it applying current stash"
