# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_clone_msg
    set -l msg $argv[1]

    echo "Repository name is required!"
    echo "Example: $msg your-repo-name"
    echo "Usages:"
    echo "  a) $msg username/repo-name"
    echo "  b) $msg username repo-name"
    echo "  c) $msg repo-name"
    echo "     For this, it's necessary to set your $msg username (login)"
    echo "     to global config before like: "
    echo "     git config --global user.$msg \"your-username\""
    echo
end
