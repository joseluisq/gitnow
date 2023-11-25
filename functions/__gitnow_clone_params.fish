# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_clone_params
    set -l repo

    if count $argv >/dev/null
        if test (count $argv) -gt 1
            set repo $argv[1]/$argv[2]
        else if echo $argv | LC_ALL=C command grep -q -E '^([a-zA-Z0-9\_\-]+)\/([a-zA-Z0-9\_\-]+)$'
            set repo $argv
        else
            set repo "%S/$argv"
        end
    end

    echo $repo
end
