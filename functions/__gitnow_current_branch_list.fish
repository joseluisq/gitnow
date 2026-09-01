# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_current_branch_list -d "Lists local branch names, one per line"
    # Ask git for clean names instead of parsing `git branch` output: no
    # `*` marker, no padding, no "(HEAD detached at ...)" line — and no
    # sed, whose `\t` handling differs between GNU and BSD (macOS).
    command git for-each-ref --format='%(refname:short)' refs/heads/ 2>/dev/null
end
