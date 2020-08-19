source $__fish_data_dir/completions/git.fish

complete -f -c move -a '(__fish_git_branches)'

complete -f -c move \
    -s u -l upstream \
    -x \
    -a '(__fish_git_branches)' \
    -d "Fetch a remote branch and switch to it applying current stash"

complete -f -c move \
    -s n -l no-apply-stash \
    -x \
    -a '(__fish_git_branches)' \
    -d "Switch to a local branch but without applying current stash" 
