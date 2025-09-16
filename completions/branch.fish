# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

# Branch command

__gitnow_load_git_functions

complete -f -k -x -c branch -a '(__fish_git_branches)' 