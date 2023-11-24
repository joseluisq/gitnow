# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_is_number -a strv
    command echo -n $strv | LC_ALL=C command grep -qE '^([0-9]+)$'
end
