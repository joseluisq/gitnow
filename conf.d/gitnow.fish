# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function _gitnow_install -e gitnow_install
    echo "Installing Gitnow..."

    # download .gitnow example file
    set -l config_file "$fish_snippets/.gitnow"
    
    echo "GitNow: Downloading default configuration file..."
    curl -sSo $config_file https://raw.githubusercontent.com/joseluisq/gitnow/master/.gitnow
    echo "GitNow: Configured and ready to use!"
end

function _gitnow_uninstall -e gitnow_uninstall
    echo "Uninstalling Gitnow..."
    command rm -f $fish_snippets/.gitnow
end

function gitnow -d "Gitnow: Speed up your Git workflow. 🐠" -a xversion
    if [ "$xversion" = "-v" ]; or [ "$xversion" = "--version" ]
        echo "GitNow version $gitnow_version"
    else
        __gitnow_manual | command less -r
        commandline -f repaint
    end
end

function state -d "Gitnow: Show the working tree status in compact way"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "state"
        return
    end

    command git status -sb
    commandline -f repaint
end

function stage -d "Gitnow: Stage files in current working directory"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "stage"
        return
    end

    set -l len (count $argv)
    set -l opts .

    if test $len -gt 0
        set opts $argv
    end

    command git add $opts
    commandline -f repaint
end

function unstage -d "Gitnow: Unstage files in current working directory"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "unstage"
        return
    end

    set -l len (count $argv)
    set -l opts .

    if test $len -gt 0
        set opts $argv
    end

    command git reset $opts
    commandline -f repaint
end

function show -d "Gitnow: Show commit detail objects"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "show"
        return
    end

    set -l len (count $argv)

    if test $len -gt 0
        command git show $argv
    else
        command git show --compact-summary HEAD
    end

    commandline -f repaint
end

function untracked -d "Gitnow: Check for untracked files and directories on current working directory"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "untracked"
        return
    end

    command git clean --dry-run -d

    commandline -f repaint
end

function commit -d "Gitnow: Commit changes to the repository"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "commit"
        return
    end

    set -l len (count $argv)

    if test $len -gt 0
        command git commit $argv
    else
        command git commit
    end

    commandline -f repaint
end

function commit-all -d "Gitnow: Add and commit all changes to the repository"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "commit-all"
        return
    end

    stage
    commit .
end

function pull -d "Gitnow: Pull changes from remote server but saving uncommitted changes"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "pull"
        return
    end

    set -l len (count $argv)
    set -l xorigin (__gitnow_current_remote)
    set -l xbranch (__gitnow_current_branch_name)
    set -l xcmd ""

    echo "⚡️ Pulling changes..."

    set -l xdefaults --rebase --autostash

    if test $len -gt 2
        set xcmd $argv

        echo "Mode: Manual"
        echo "Default flags: $xdefaults"
        echo
    else
        echo "Mode: Auto"
        echo "Default flags: $xdefaults"

        if test $len -eq 1
            set xbranch $argv[1]
        end

        if test $len -eq 2
            set xorigin $argv[1]
            set xbranch $argv[2]
        end

        set xcmd $xorigin $xbranch
        set -l xremote_url (command git config --get "remote.$xorigin.url")

        echo "Remote URL: $xorigin ($xremote_url)"
        echo "Remote branch: $xbranch"
        echo
    end

    command git pull $xcmd $xdefaults
    commandline -f repaint
end

# Git push with --set-upstream
# Shortcut inspired from https://github.com/jamiew/git-friendly
function push -d "Gitnow: Push commit changes to remote repository"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "push"
        return
    end

    set -l opts $argv
    set -l xorigin (__gitnow_current_remote)
    set -l xbranch (__gitnow_current_branch_name)

    echo "🚀 Pushing changes..."

    if test (count $opts) -eq 0
        set opts $xorigin $xbranch
        set -l xremote_url (command git config --get "remote.$xorigin.url")

        echo "Mode: Auto"
        echo "Remote URL: $xorigin ($xremote_url)"
        echo "Remote branch: $xbranch"
    else
        echo "Mode: Manual"
    end

    echo

    command git push --set-upstream $opts
    commandline -f repaint
end

function upstream -d "Gitnow: Commit all changes and push them to remote server"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "upstream"
        return
    end

    commit-all
    push
end

function feature -d "GitNow: Creates a new Gitflow feature branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "feature"
        return
    end

    __gitnow_gitflow_branch "feature" $xbranch
    commandline -f repaint
end

function hotfix -d "GitNow: Creates a new Gitflow hotfix branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "hotfix"
        return
    end

    __gitnow_gitflow_branch "hotfix" $xbranch
    commandline -f repaint
end

function bugfix -d "GitNow: Creates a new Gitflow bugfix branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "bugfix"
        return
    end

    __gitnow_gitflow_branch "bugfix" $xbranch
    commandline -f repaint
end

function release -d "GitNow: Creates a new Gitflow release branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "release"
        return
    end

    __gitnow_gitflow_branch "release" $xbranch
    commandline -f repaint
end

function move -d "GitNow: Switch from current branch to another but stashing uncommitted changes"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "move"
        return
    end

    set -l v_upstream
    set -l v_no_apply_stash
    set -l v_branch

    for v in $argv
        switch $v
            case -u --upstream
                set v_upstream $v
            case -n --no-apply-stash
                set v_no_apply_stash $v
            case -nu -un
                set v_upstream "-u"
                set v_no_apply_stash "-n"
            case '*'
                set v_branch $v
        end
    end

    # No branch defined
    if not test -n "$v_branch"
        echo "Provide a valid branch name to switch to."

        commandline -f repaint
        return
    end

    if test -n "$v_upstream"
        command git fetch (__gitnow_current_remote) $v_branch
    end

    set -l v_found (__gitnow_check_if_branch_exist $v_branch)

    # Branch was not found 
    # Branch was not found 
    # Branch was not found 
    if not test $v_found -eq 1
        echo "Branch `$v_branch` was not found. No possible to switch."
        echo "Tip: Use -u (--upstream) flag to fetch a remote branch."

        commandline -f repaint
        return
    end

    # Prevent same branch switching
    if [ "$v_branch" = (__gitnow_current_branch_name) ]
        echo "Branch `$v_branch` is the same as current branch. Nothing to do."
        commandline -f repaint
        return
    end

    command git stash
    command git checkout $v_branch

    # --no-apply-stash
    if test -n "$v_no_apply_stash"
        echo "Stashed changes were not applied. Use `git stash pop` to apply them."
    else
        command git stash pop
        echo "Stashed changes applied."
    end

    commandline -f repaint
end

function logs -d "Gitnow: Shows logs in a fancy way"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "logs"
        return
    end

    set -l args HEAD

    if test -n "$argv"
        set args $argv
    end

    command git log $args --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit | command less -r

    commandline -f repaint
end

function github -d "Gitnow: Clone a GitHub repository using SSH"
    set -l repo (__gitnow_clone_params $argv)
    __gitnow_clone_repo $repo "github"

    commandline -f repaint
end

function bitbucket -d "Gitnow: Clone a Bitbucket Cloud repository using SSH"
    set -l repo (__gitnow_clone_params $argv)
    __gitnow_clone_repo $repo "bitbucket"

    commandline -f repaint
end
