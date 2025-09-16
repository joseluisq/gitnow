# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_check_create_branch -a xbranch
    set -l xfound (__gitnow_check_if_branch_exist $xbranch)

    if test -n "$xbranch"
        if test $xfound -eq 1
            echo "Branch `$xbranch` already exists. Nothing to do."
        else
            command git stash
            __gitnow_new_branch_switch "$xbranch"
            command git stash pop
        end
    else
        echo "Branch name is required."
    end
end
