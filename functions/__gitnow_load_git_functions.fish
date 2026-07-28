# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_load_git_functions -d "Gitnow: Load fish git functions on demand"
    if not functions -q __fish_git_branches __fish_git_tags
        complete -C"git " >/dev/null 2>&1
    end
end
