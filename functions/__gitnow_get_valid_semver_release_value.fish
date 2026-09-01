# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_get_valid_semver_release_value -a tagv
    string match -rg '^v?(\d+\.\d+\.\d+)' -- $tagv
end
