source $__fish_data_dir/completions/git.fish

# Merge command

complete -f -x -c merge -a '(__fish_git_branches)'

complete -f -x -c merge \
    -s h -l help \
    -d "Show information about the options for this command"

complete -f -x -c merge \
    -s a -l abort \
    -d "Abort conflicted merge"

complete -f -x -c merge \
    -s c -l continue \
    -d "Continue merge"

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


# Tag command

complete -f -x -c tag \
    -d "List all tags in a lexicographic order and treating tag names as versions"

complete -f -x -c tag -a '(__fish_git_tags)'

complete -f -x -c tag \
    -s h -l help \
    -d "Show information about the options for this command"

complete -f -x -c tag \
    -s l -l latest \
    -d "Show only the latest Semver release tag version (no suffixed ones or others)"

complete -f -x -c tag \
    -s x -l major \
    -d "Tag auto-incrementing a major version number"

complete -f -x -c tag \
    -s y -l minor \
    -d "Tag auto-incrementing a minor version number"

complete -f -x -c tag \
    -s z -l patch \
    -d "Tag auto-incrementing a patch version number"

# TODO: pre-release versions are not supported yet
# complete -f -x -c tag \
#     -s a -l premajor \
#     -d "Tag auto-incrementing a premajor version number"

# complete -f -x -c tag \
#     -s b -l preminor \
#     -d "Tag auto-incrementing a preminor version number"

# complete -f -x -c tag \
#     -s c -l prepatch \
#     -d "Tag auto-incrementing a prepatch version number"
