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

# adapted from https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
function __gitnow_slugify
    echo $argv | command iconv -t ascii//TRANSLIT | command sed -E 's/[^a-zA-Z0-9\-]+/_/g' | command sed -E 's/^(-|_)+|(-|_)+$//g'
end

function __gitnow_clone_repo
    set -l repo $argv[1]
    set -l platform $argv[2]

    if test -n "$repo"
        set -l ok 1

        if echo $repo | command grep -q -E '^[\%S].+'
            set -l user (command git config --global user.$platform)

            if test -n "$user"
                set -l repor (echo $repo | command sed -e "s/^%S/$user/")
                set repo $repor
            else
                set ok 0
            end
        end

        if test $ok -eq 1
            if [ "$platform" = "github" ]
                set url github.com
            end

            if [ "$platform" = "bitbucket" ]
                set url bitbucket.org
            end

            set -l repo_url git@$url:$repo.git

            echo "📦 Remote repository: $repo_url"
            command git clone $repo_url
        else
            __gitnow_clone_msg $platform
        end
    else
        __gitnow_clone_msg $platform
    end
end

function __gitnow_clone_msg
    set -l msg $argv[1]

    echo "Repository name is required!"
    echo "Example: $msg your-repo-name"
    echo "Usages:"
    echo "  a) $msg username/repo-name"
    echo "  b) $msg username repo-name"
    echo "  c) $msg repo-name"
    echo "     For this, it's necessary to set your $msg username (login)"
    echo "     to global config before like: "
    echo "     git config --global user.$msg \"your-username\""
    echo
end

function __gitnow_check_if_branch_exist
    if test (count $argv) -eq 1
        set -l xbranch $argv[1]
        set -l xbranch_list (__gitnow_current_branch_list)
        set -l xfound 0

        for b in $xbranch_list
            if [ "$xbranch" = "$b" ]
                set xfound 1
                break
            end
        end

        echo $xfound
    else
        echo "Provide a valid branch name."
    end
end

function __gitnow_clone_params
    set -l repo

    if count $argv >/dev/null
        if test (count $argv) -gt 1
            set repo $argv[1]/$argv[2]
        else if echo $argv | command grep -q -E '^([a-zA-Z0-9\_\-]+)\/([a-zA-Z0-9\_\-]+)$'
            set repo $argv
        else
            set repo "%S/$argv"
        end
    end

    echo $repo
end

function __gitnow_gitflow_branch -a xprefix -a xbranch
    set xbranch (__gitnow_slugify $xbranch)
    set -l xbranch_full "$xprefix/$xbranch"
    set -l xfound (__gitnow_check_if_branch_exist $xbranch_full)

    if test $xfound -eq 1
        echo "Branch `$xbranch_full` already exists. Nothing to do."
    else
        command git stash
        __gitnow_new_branch_switch "$xbranch_full"
        command git stash pop
    end
end

function __gitnow_msg_not_valid_repository -a cmd
    echo "Gitnow ($cmd): Current directory is not a valid Git repository."
end

function __gitnow_current_branch_name
    command git symbolic-ref --short HEAD 2>/dev/null
end

function __gitnow_current_branch_list
    command git branch --list --no-color | sed -E "s/^(\*?[ \t]*)//g" 2>/dev/null
end

function __gitnow_current_remote
    set -l branch_name (__gitnow_current_branch_name)
    command git config "branch.$branch_name.remote" 2>/dev/null; or echo origin
end

function __gitnow_is_git_repository
    command git rev-parse --git-dir >/dev/null 2>&1
end

function __gitnow_has_uncommited_changes
    command git diff-index --quiet HEAD -- || echo "1" 2>&1
end

function __gitnow_get_latest_tag
    command git tag --sort=-creatordate | head -n1 2>/dev/null
end

# lexicographic order and tag names treated as versions
# https://stackoverflow.com/a/52680984/2510591
function __gitnow_get_tags_ordered
    command git -c 'versionsort.suffix=-' tag --list --sort=-version:refname
end

function __gitnow_get_latest_semver_release_tag
    for tg in (__gitnow_get_tags_ordered)
        if echo $tg | grep -qE '^v?([0-9]+).([0-9]+).([0-9]+)$'
            echo $tg 2>/dev/null
            break
        end
    end
end

function __gitnow_increment_number -a strv
    command echo $strv | awk '
        function increment(val) {
            if (val ~ /[0-9]+/) { return val + 1 }
            return val
        }
        { print increment($0) }
    ' 2>/dev/null
end

function __gitnow_get_valid_semver_release_value -a tagv
    command echo $tagv | command sed -n 's/^v\\{0,1\\}\([0-9].[0-9].[0-9]*\)\([}]*\)/\1/p' 2>/dev/null
end

function __gitnow_get_valid_semver_prerelease_value -a tagv
    command echo $tagv | command sed -n 's/^v\\{0,1\\}\([0-9].[0-9].[0-9]-[a-zA-Z0-9\-_.]*\)\([}]*\)/\1/p' 2>/dev/null
end

function __gitnow_is_number -a strv
    command echo -n $strv | command grep -qE '^([0-9]+)$'
end
