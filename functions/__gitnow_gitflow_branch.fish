# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_gitflow_branch -a xprefix -a xbranch
    set xbranch (__gitnow_slugify $xbranch)
    set -l xbranch_full "$xprefix/$xbranch"
    set -l xfound (__gitnow_check_if_branch_exist $xbranch_full)

    if test $xfound -eq 1
        echo "Branch `$xbranch_full` already exists. Nothing to do."
    else
        set -l v_uncommited (__gitnow_has_uncommited_changes)

        if test -n "$v_uncommited"
            command git stash
        end

        __gitnow_new_branch_switch "$xbranch_full"

        if test -n "$v_uncommited"
            command git stash pop
        end
    end
end
