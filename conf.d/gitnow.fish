# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

set -g gitnow_version 2.12.0

# Default global variables
set -q GITNOW_CONFIG_FILE; or set -g GITNOW_CONFIG_FILE ~/.gitnow
set -g gitnow_commands 'all' 'assume' 'bitbucket' 'bugfix' 'commit' 'commit-all' 'feature' 'github' 'gitnow' 'hotfix' 'logs' 'merge' 'move' 'pull' 'push' 'release' 'show' 'stage' 'state' 'tag' 'unstage' 'untracked' 'upstream'

if set -q __fish_config_dir
    set -g fish_config "$__fish_config_dir"
else
    set -q XDG_CONFIG_HOME
        and set -g fish_config "$XDG_CONFIG_HOME/fish"
        or set -g fish_config "~/.config/fish"
end

set -q fish_snippets; or set -g fish_snippets "$fish_config/conf.d"

__gitnow_load_config

# Other specific global variables
set -g g_current_branch

function __gitnow_install -e gitnow_install
    echo (gitnow -v)" is installed and ready to use!"
    echo "Just run the `gitnow` command if you want explore the API."
end

function __gitnow_uninstall -e gitnow_uninstall
    echo "GitNow was uninstalled successfully."
end

function gitnow -d "Gitnow: Speed up your Git workflow. 🐠" -a xversion
    if [ "$xversion" = "-v" ]; or [ "$xversion" = "--version" ]
        echo "GitNow version $gitnow_version"
    else
        __gitnow_manual | command less -r
    end
end

function state -d "Gitnow: Show the working tree status in compact way"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "state"
        return
    end

    command git status -sb
end

function stage -d "Gitnow: Stage files in current working directory" -w 'git add'
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
end

function unstage -d "Gitnow: Unstage files in current working directory" -w 'git reset'
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
end

function show -d "Gitnow: Show commit detail objects" -w 'git show'
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "show"
        return
    end

    set -l len (count $argv)

    if test $len -gt 0
        command git show $argv
    else
        command git show --compact-summary --patch HEAD
    end
end

function untracked -d "Gitnow: Check for untracked files and directories on current working directory"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "untracked"
        return
    end

    command git clean --dry-run -d

end

function commit -d "Gitnow: Commit changes to the repository" -w 'git commit'
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
end

function commit-all -d "Gitnow: Add and commit all changes to the repository"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "commit-all"
        return
    end

    stage
    commit .
end

function pull -d "Gitnow: Pull changes from remote server but stashing uncommitted changes" -w 'git pull'
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "pull"
        return
    end

    set -l len (count $argv)
    set -l xorigin (__gitnow_current_remote)
    set -l xbranch (__gitnow_current_branch_name)
    set -l xcmd ""

    echo "⚡️ Pulling changes..."

    set -l xdefaults --rebase --autostash --tags

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
end

# Git push with --set-upstream
# Shortcut inspired from https://github.com/jamiew/git-friendly
function push -d "Gitnow: Push commit changes to remote repository" -w 'git push'
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "push"
        return
    end

    set -l opts $argv
    set -l xorigin (__gitnow_current_remote)
    set -l xbranch (__gitnow_current_branch_name)


    if test (count $opts) -eq 0
        set opts $xorigin $xbranch
        set -l xremote_url (command git config --get "remote.$xorigin.url")

        echo "🚀 Pushing changes..."
        echo "Mode: Auto"
        echo "Remote URL: $xorigin ($xremote_url)"
        echo "Remote branch: $xbranch"
    else
        set -l v_mode "auto"

        for v in $argv
            switch $v
                case -t --tags
                    set opts $xorigin $xbranch --follow-tags
                    set -l xremote_url (command git config --get "remote.$xorigin.url")

                    echo "🚀 Pushing changes..."
                    echo "Mode: Auto (incl. tags)"
                    echo "Remote URL: $xorigin ($xremote_url)"
                    echo "Remote branch: $xbranch"
                case -h --help
                    echo "NAME"
                    echo "      Gitnow: push - Push current branch to default origin"
                    echo "OPTIONS:"
                    echo "      -t --tags               (auto mode) include annotated tags that relate to the commits"
                    echo "      -h --help               Show information about the options for this command"
                    return
                case -\*
                case '*'
                    set -l v_mode "manual"
                    echo "Mode: Manual"
            end
        end
    end

    echo

    command git push --set-upstream $opts
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
end

function hotfix -d "GitNow: Creates a new Gitflow hotfix branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "hotfix"
        return
    end

    __gitnow_gitflow_branch "hotfix" $xbranch
end

function bugfix -d "GitNow: Creates a new Gitflow bugfix branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "bugfix"
        return
    end

    __gitnow_gitflow_branch "bugfix" $xbranch
end

function release -d "GitNow: Creates a new Gitflow release branch from current branch" -a xbranch
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "release"
        return
    end

    __gitnow_gitflow_branch "release" $xbranch
end

function merge -d "GitNow: Merges given branch into the active one"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "merge"
        return
    end

    set -l len (count $argv)
    if test $len -eq 0
        echo "Merge: No argument given, needs one parameter"
        return
    end

    set -l v_abort
    set -l v_continue
    set -l v_branch

    for v in $argv
        switch $v
            case -a --abort
                set v_abort $v
            case -c --continue
                set v_continue $v
            case -h --help
                echo "NAME"
                echo "      Gitnow: merge - Merge given branch into the active one"
                echo "EXAMPLES"
                echo "      merge <branch to merge>"
                echo "OPTIONS:"
                echo "      -a --abort              Abort a conflicted merge"
                echo "      -c --continue           Continue a conflicted merge"
                echo "      -h --help               Show information about the options for this command"
                return
            case -\*
            case '*'
                set v_branch $v
        end
    end

    # abort
    if test "$v_abort";
        echo "Abort the current merge"
        command git merge --abort
        return
    end

    # continue
    if test "$v_continue";
        echo "Continue the current merge"
        command git merge --continue
        return
    end

    # No branch defined
    if not test -n "$v_branch"
        echo "Provide a valid branch name to merge."
        return
    end

    set -l v_found (__gitnow_check_if_branch_exist $v_branch)

    # Branch was not found
    if test $v_found -eq 0;
        echo "Local branch `$v_branch` was not found. Not possible to merge."

        return
    end

    # Detect merging current branch
    if [ "$v_branch" = (__gitnow_current_branch_name) ]
        echo "Branch `$v_branch` is the same as current branch. Nothing to do."
        return
    end

    command git merge $v_branch
end

function move -d "GitNow: Switch from current branch to another but stashing uncommitted changes" -a args
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "move"
        return
    end

    set -l v_upstream
    set -l v_no_apply_stash
    set -l v_branch
    set -l v_prev

    for v in $argv
        switch $v
            case -u --upstream
                set v_upstream $v
            case -n --no-apply-stash
                set v_no_apply_stash $v
            case -nu -un
                set v_upstream "-u"
                set v_no_apply_stash "-n"
            case -p --prev
                set v_prev "true"
            case -h --help
                echo "NAME"
                echo "      Gitnow: move - Switch from current branch to another but stashing uncommitted changes"
                echo "EXAMPLES"
                echo "      move <branch to switch to>"
                echo "      move -"
                echo "OPTIONS:"
                echo "      -n --no-apply-stash     Switch to a local branch but without applying current stash"
                echo "      -u --upstream           Fetch a remote branch and switch to it applying current stash. It can be combined with --no-apply-stash"
                echo "      -p --prev               Switch to a previous branch if different than the current one (equivalent to \"move -\"). It uses `--no-apply-stash` option by default."
                echo "      -h --help               Show information about the options for this command"
                return
            case -\*
            case '*'
                set v_branch $v
        end
    end

    # Move to prev branch either via the --prev option or the "-" shorthand char
    if begin test -n "$v_prev"; or [ "$args" = "-" ]; end
        if begin test -z "$g_current_branch"; or [ "$g_current_branch" = (__gitnow_current_branch_name) ]; end
            echo "Previous branch not found or the same as current one. Nothing to do."
            echo "Tip: Previous branch switching only works via the `move` command."
            return
        end

        echo "Previous branch found, switching to `$g_current_branch` (using `--no-apply-stash` option)."
        move -n $g_current_branch
        return
    end

    # No branch defined
    if not test -n "$v_branch"
        echo "Provide a valid branch name to switch to."
        return
    end

    set -l v_fetched 0

    # Fetch branch from remote
    if test -n "$v_upstream"
        set -l v_remote (__gitnow_current_remote)
        command git fetch $v_remote $v_branch:refs/remotes/$v_remote/$v_branch
        command git checkout --track $v_remote/$v_branch
        return
    end

    set -l v_found (__gitnow_check_if_branch_exist $v_branch)

    # Branch was not found
    if begin test $v_found -eq 0; and test $v_fetched -eq 0; end
        echo "Branch `$v_branch` was not found locally. No possible to switch."
        echo "Tip: Use -u (--upstream) flag to fetch a remote branch."
        return
    end

    # Prevent same branch switching
    if [ "$v_branch" = (__gitnow_current_branch_name) ]
        echo "Branch `$v_branch` is the same as current branch. Nothing to do."
        return
    end

    set -l v_uncommited (__gitnow_has_uncommited_changes)

    # Stash changes before checkout for uncommited changes only
    if test $v_uncommited
        command git stash
    end

    set g_current_branch (__gitnow_current_branch_name)
    command git checkout $v_branch

    # --no-apply-stash
    if test -n "$v_no_apply_stash"
        echo "Changes were stashed but not applied by default. Use `git stash pop` to apply them."
    end

    if begin test $v_uncommited; and not test -n "$v_no_apply_stash"; end
        command git stash pop
        echo "Stashed changes were applied."
    end
end

function logs -d "Gitnow: Shows logs in a fancy way"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "logs"
        return
    end

    set -l v_max_commits "80"
    set -l v_args

    for v in $argv
        switch $v
            case -h --help
                echo "NAME"
                echo "      Gitnow: logs - Show logs in a fancy way (first $v_max_commits commits by default)"
                echo "EXAMPLES"
                echo "      logs [git log options]"
                echo "EXTRA OPTIONS:"
                echo "      -h, --help      Show information about the options for this command"
                return
            case -\*
            case '*'
                set v_args $argv
                break
        end
    end

    if test -n "$v_args"
        set v_max_commits
    else
        set v_max_commits "-$v_max_commits"
    end

    LC_ALL=C command git log $v_max_commits $v_args --color --graph \
        --pretty=format:"%C(red)%h%C(reset)%C(yellow)%d%Creset %s %C(green italic)(%cr)%C(reset) %C(blue)%an%C(reset) %C(white dim)%GK %C(reset)" --abbrev-commit \
        | command less -R
end

function tag -d "Gitnow: Tag commits following Semver"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "tag"
        return
    end

    set -l v_major
    set -l v_minor
    set -l v_patch
    set -l v_premajor
    set -l v_preminor
    set -l v_prepatch

    set -l opts

    # NOTE: this function only gets the latest *Semver release version* but no suffixed ones or others
    set -l v_latest (__gitnow_get_latest_semver_release_tag)

    for v in $argv
        switch $v
            case -x --major
                set v_major $v
            case -y --minor
                set v_minor $v
            case -z --patch
                set v_patch $v
            case -a --annotate
                set opts $opts $v

            # TODO: pre-release versions are not supported yet
            # case -a --premajor
            #     set v_premajor $v
            # case -b --preminor
            #     set v_preminor $v
            # case -c --prepatch
            #     set v_prepatch $v

            case -l --latest
                if not test -n "$v_latest"
                    echo "There is no any tag created yet."
                else
                    echo $v_latest
                end

                return
            case -h --help
                echo "NAME"
                echo "      Gitnow: tag - List or tag commits following The Semantic Versioning 2.0.0 (Semver) [1]"
                echo "      [1] https://semver.org/"
                echo "EXAMPLES"
                echo "      List tags: tag"
                echo "      Custom tag: tag <my tag name>"
                echo "      Semver tag: tag --major"
                echo "OPTIONS:"
                echo "      Without options all tags are listed in a lexicographic order and tag names are treated as versions"
                echo "      -x --major         Tag auto-incrementing a major version number"
                echo "      -y --minor         Tag auto-incrementing a minor version number"
                echo "      -z --patch         Tag auto-incrementing a patch version number"
                echo "      -l --latest        Show only the latest Semver release tag version (no suffixed ones or others)"
                echo "      -a --annotate      Create as annotated tag"
                echo "      -h --help          Show information about the options for this command"

                # TODO: pre-release versions are not supported yet
                # echo "      -a --premajor      Tag auto-incrementing a premajor version number"
                # echo "      -b --preminor      Tag auto-incrementing a preminor version number"
                # echo "      -c --prepatch      Tag auto-incrementing a prepatch version number"

                return
            case -\*
            case '*'
                return
        end
    end

    # List all tags in a lexicographic order and treating tag names as versions
    if test -z "$argv"
        __gitnow_get_tags_ordered
        return
    end

    # Major version tags
    if test -n "$v_major"
        if not test -n "$v_latest"
            command git tag $opts v1.0.0
            echo "First major tag \"v1.0.0\" was created."
            return
        else
            set -l vstr (__gitnow_get_valid_semver_release_value $v_latest)

            # Validate Semver format before to proceed
            if not test -n "$vstr"
                echo "The latest tag \"$v_latest\" has no a valid Semver format."
                return
            end

            set -l x (echo $vstr | LC_ALL=C command awk -F '.' '{print $1}')
            set -l prefix (echo $v_latest | LC_ALL=C command awk -F "$vstr" '{print $1}')
            set x (__gitnow_increment_number $x)
            set -l xyz "$prefix$x.0.0"

            command git tag $opts $xyz
            echo "Major tag \"$xyz\" was created."
            return
        end
    end

    # Minor version tags
    if test -n "$v_minor"
        if not test -n "$v_latest"
            command git tag $opts v0.1.0
            echo "First minor tag \"v0.1.0\" was created."
            return
        else
            set -l vstr (__gitnow_get_valid_semver_release_value $v_latest)

            # Validate Semver format before to proceed
            if not test -n "$vstr"
                echo "The latest tag \"$v_latest\" has no a valid Semver format."
                return
            end

            set -l x (echo $vstr | LC_ALL=C command awk -F '.' '{print $1}')
            set -l y (echo $vstr | LC_ALL=C command awk -F '.' '{print $2}')
            set -l prefix (echo $v_latest | LC_ALL=C command awk -F "$vstr" '{print $1}')
            set y (__gitnow_increment_number $y)
            set -l xyz "$prefix$x.$y.0"

            command git tag $opts $xyz
            echo "Minor tag \"$xyz\" was created."
            return
        end
    end


    # Patch version tags
    if test -n "$v_patch"
        if not test -n "$v_latest"
            command git tag $opts v0.0.1
            echo "First patch tag \"v0.1.0\" was created."
            return
        else
            set -l vstr (__gitnow_get_valid_semver_release_value $v_latest)

            # Validate Semver format before to proceed
            if not test -n "$vstr"
                echo "The latest tag \"$v_latest\" has no a valid Semver format."
                return
            end

            set -l x (echo $vstr | LC_ALL=C command awk -F '.' '{print $1}')
            set -l y (echo $vstr | LC_ALL=C command awk -F '.' '{print $2}')
            set -l z (echo $vstr | LC_ALL=C command awk -F '.' '{print $3}')
            set -l s (echo $z | LC_ALL=C command awk -F '-' '{print $1}')

            if __gitnow_is_number $s
                set -l prefix (echo $v_latest | LC_ALL=C command awk -F "$vstr" '{print $1}')
                set s (__gitnow_increment_number $s)
                set -l xyz "$prefix$x.$y.$s"

                command git tag $opts $xyz
                echo "Patch tag \"$xyz\" was created."
            else
                echo "No patch version found."
            end

            return
        end
    end

    # TODO: pre-release versions are not supported yet
    # TODO: Premajor version tags
    # TODO: Preminor version tags
    # TODO: Prepatch version tags
end

function assume -d "Gitnow: Ignore files temporarily"
    if not __gitnow_is_git_repository
        __gitnow_msg_not_valid_repository "assume"
        return
    end

    set -l v_assume_unchanged "--assume-unchanged"
    set -l v_files

    for v in $argv
        switch $v
            case -n --no-assume
                set v_assume_unchanged "--no-assume-unchanged"
            case -h --help
                echo "NAME"
                echo "      Gitnow: assume - Ignores changes in certain files temporarily"
                echo "OPTIONS:"
                echo "      -n --no-assume  No assume unchanged files to be ignored (revert option)"
                echo "      -h --help       Show information about the options for this command"
                return
            case -\*
            case '*'
                set v_files $v_files $v
        end
    end

    if test (count $v_files) -lt 1
        echo "Provide files in order to ignore them temporarily. E.g `assume Cargo.lock`"
        return
    end

    command git update-index $v_assume_unchanged $v_files
end

function github -d "Gitnow: Clone a GitHub repository using SSH"
    set -l repo (__gitnow_clone_params $argv)
    __gitnow_clone_repo $repo "github"
end

function bitbucket -d "Gitnow: Clone a Bitbucket Cloud repository using SSH"
    set -l repo (__gitnow_clone_params $argv)
    __gitnow_clone_repo $repo "bitbucket"
end
