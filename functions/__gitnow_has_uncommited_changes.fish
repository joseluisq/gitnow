# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_has_uncommited_changes
    # Refresh stat-only differences first so a touched-but-unchanged file
    # doesn't report as dirty (a no-op `git stash` followed by `git stash pop`
    # would pop an older, unrelated stash entry).
    command git update-index -q --refresh 2>/dev/null
    command git diff-index --quiet HEAD -- 2>/dev/null; or echo "1"
end
