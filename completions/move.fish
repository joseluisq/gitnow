# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

# Move command

__gitnow_load_git_functions

complete -f -x -c move -a '(__fish_git_branches)'

complete -f -x -c move \
    -s h -l help \
    -d "Show information about the options for this command"

complete -f -x -c move \
    -s p -l prev \
    -d "Switch to a previous branch using the `--no-apply-stash` option (equivalent to \"move -\")"

complete -f -x -c move \
    -s n -l no-apply-stash \
    -a '(__fish_git_branches)' \
    -d "Switch to a local branch but without applying current stash"

complete -f -x -c move \
    -s u -l upstream \
    -a '(__fish_git_branches)' \
    -d "Fetch a remote branch and switch to it applying current stash"
