# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_check_create_branch -a xbranch
    if test -z "$xbranch"
        echo "Branch name is required."
        return
    end

    set xbranch (__gitnow_slugify $xbranch)

    if test -z "$xbranch"
        echo "Branch name is required."
        return
    end

    set -l xfound (__gitnow_check_if_branch_exist $xbranch)

    if test $xfound -eq 1
        echo "Branch `$xbranch` already exists. Nothing to do."
    else
        set -l v_uncommited (__gitnow_has_uncommited_changes)

        if test -n "$v_uncommited"
            command git stash
        end

        __gitnow_new_branch_switch "$xbranch"

        if test -n "$v_uncommited"
            command git stash pop
        end
    end
end
