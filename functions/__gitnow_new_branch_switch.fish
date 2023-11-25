# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_new_branch_switch
    set -l branch_name $argv[1]

    if test (count $argv) -eq 1
        set branch_name $branch_name

        command git checkout -b $branch_name
    else
        echo "Provide a branch name."
    end
end
