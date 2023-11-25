# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_load_git_functions -d "Gitnow: Load fish git functions on demand"
    if begin not type -q __fish_git_branches; or not type -q __fish_git_tags; end
        source $__fish_data_dir/completions/git.fish
    end
end
