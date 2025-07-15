# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

# Move command

__gitnow_load_git_functions

complete -f -k -x -c move -a '(__fish_git_branches)'

complete -f -k -x -c move \
    -s h -l help \
    -d "Show information about the options for this command"

complete -f -x -c move \
    -s p -l prev \
    -d "Switch to a previous branch using the `--no-apply-stash` option (equivalent to \"move -\")"

complete -f -k -x -c move \
    -s n -l no-apply-stash \
    -a '(__fish_git_branches)' \
    -d "Switch to a local branch but without applying current stash"

complete -f -k -x -c move \
    -s u -l upstream \
    -a '(__fish_git_branches)' \
    -d "Fetch a remote branch and switch to it applying current stash"

complete -f -k -x -c move \
    -s r -l remote-branch \
    -n 'contains -- -u (commandline -opc); or contains -- --upstream (commandline -opc)' \
    -a '(__fish_git_branches)' \
    -d "Use a custom remote branch path like '<origin>/<master>' when wanting to switch."
