# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_clone_repo
    set -l repo $argv[1]
    set -l platform $argv[2]

    if test -n "$repo"
        set -l ok 1

        if echo $repo | LC_ALL=C command grep -q -E '^[\%S].+'
            set -l user (command git config --global user.$platform)

            if test -n "$user"
                set -l repor (echo $repo | LC_ALL=C command sed -e "s/^%S/$user/")
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
