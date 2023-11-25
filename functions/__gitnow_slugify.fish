# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

# adapted from https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
function __gitnow_slugify
    echo $argv | LC_ALL=C command iconv -t ascii//TRANSLIT | LC_ALL=C command sed -E 's/[^a-zA-Z0-9\-]+/_/g' | LC_ALL=C command sed -E 's/^(-|_)+|(-|_)+$//g'
end
