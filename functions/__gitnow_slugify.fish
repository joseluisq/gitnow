# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

# adapted from https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
function __gitnow_slugify
    # Lowercase + ASCII transliteration; `/` and `.` are preserved since they
    # are valid in git branch names (e.g. `fix/v1.2`).
    string join ' ' -- $argv | command iconv -f UTF-8 -t ascii//TRANSLIT | string lower | string replace -ra '[^a-z0-9./-]+' '_' | string replace -ra '^[-_./]+|[-_./]+$' ''
end
