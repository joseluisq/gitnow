source $__fish_data_dir/completions/git.fish

complete -f -c move -a '(__fish_git_branches)'
