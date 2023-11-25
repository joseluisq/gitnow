# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_get_latest_tag
    command git tag --sort=-creatordate | head -n1 2>/dev/null
end
