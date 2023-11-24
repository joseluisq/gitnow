# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

# Tag command

__gitnow_load_git_functions

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
