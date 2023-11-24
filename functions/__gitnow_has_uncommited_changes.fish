# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_has_uncommited_changes
    command git diff-index --quiet HEAD -- || echo "1" 2>&1
end
