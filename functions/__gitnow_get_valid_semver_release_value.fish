# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_get_valid_semver_release_value -a tagv
    command echo $tagv | LC_ALL=C command sed -n 's/^v\\{0,1\\}\([0-9].[0-9].[0-9]*\)\([}]*\)/\1/p' 2>/dev/null
end
