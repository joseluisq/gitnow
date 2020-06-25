# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_manual -d "Gitnow: Manual page like"
    echo (set_color --bold)"NAME"(set_color normal)
    echo "      GitNow — Speed up your Git workflow. 🐠"
    echo
    echo (set_color --bold)"VERSION"(set_color normal)
    echo "      $gitnow_version"
    echo
    echo (set_color --bold)"DESCRIPTION"(set_color normal)
    echo "      GitNow contains a rich command set that provides high-level operations on the top of Git(1)."
    echo "      A Fish Shell(2) alternative inspired by git-friendly(3)."
    echo
    echo "      (1) https://git-scm.com/"
    echo "      (2) https://fishshell.com/"
    echo "      (3) https://github.com/jamiew/git-friendly"
    echo
    echo (set_color --bold)"COMMANDS"(set_color normal)
    echo "      "(set_color --bold)"state"(set_color normal)
    echo "        Show the working tree status in compact way."
    echo
    echo "      "(set_color --bold)"stage"(set_color normal)
    echo "        Stage files in current working directory."
    echo
    echo "      "(set_color --bold)"unstage"(set_color normal)
    echo "        Unstage files in current working directory."
    echo
    echo "      "(set_color --bold)"show"(set_color normal)
    echo "        Show commit detail objects."
    echo
    echo "      "(set_color --bold)"untracked"(set_color normal)
    echo "        Check for untracked files and directories that could be removed."
    echo
    echo "      "(set_color --bold)"commit"(set_color normal)
    echo "        Commit changes to the repository."
    echo
    echo "      "(set_color --bold)"commit-all"(set_color normal)
    echo "        Add and commit all changes to the repository."
    echo
    echo "      "(set_color --bold)"pull"(set_color normal)
    echo "        Pull changes from remote server but saving uncommitted changes."
    echo
    echo "      "(set_color --bold)"push"(set_color normal)
    echo "        Push commit changes to remote repository."
    echo
    echo "      "(set_color --bold)"upstream"(set_color normal)
    echo "        Commit all changes and push them to remote server."
    echo
    echo "      "(set_color --bold)"move"(set_color normal)
    echo "        Switch from current branch to another but stashing uncommitted changes."
    echo
    echo "      "(set_color --bold)"feature"(set_color normal)
    echo "        Creates a new feature (Gitflow) branch from current branch."
    echo
    echo "      "(set_color --bold)"hotfix"(set_color normal)
    echo "        Creates a new hotfix (Gitflow) branch from current branch."
    echo
    echo "      "(set_color --bold)"bugfix"(set_color normal)
    echo "        Creates a new bugfix (Gitflow) branch from current branch."
    echo
    echo "      "(set_color --bold)"release"(set_color normal)
    echo "        Creates a new release (Gitflow) branch from current branch."
    echo
    echo "      "(set_color --bold)"logs"(set_color normal)
    echo "        Shows logs in a fancy way."
    echo
    echo "      "(set_color --bold)"github"(set_color normal)
    echo "        Clone a GitHub repository using SSH."
    echo
    echo "      "(set_color --bold)"bitbucket"(set_color normal)
    echo "        Clone a Bitbucket Cloud repository using SSH."
    echo
    echo (set_color --bold)"KEYBINDINGS"(set_color normal)
    echo "      state           Alt + S"
    echo "      stage           Alt + E"
    echo "      unstage         Ctrl + E"
    echo "      show            Alt + M"
    echo "      commit-all      Alt + C"
    echo "      pull            Alt + D"
    echo "      push            Alt + P"
    echo "      upstream        Alt + U"
    echo "      feature(1)      Alt + F"
    echo "      hotfix(1)       Alt + H"
    echo "      logs            Alt + L"
    echo
    echo "      (1) This command key binding will creates a new branch taking as name some text of the clipboard."
    echo
    echo (set_color --bold)"CONFIGURATION"(set_color normal)
    echo "      For a custom configuration (for example keybindings) place a "(set_color --bold)"~/.gitflow"(set_color normal)" file (1) in your home directory."
    echo
    echo "      (1) An example file it can be found on "(set_color --bold)https://github.com/joseluisq/gitnow/tree/master/.gitnow(set_color normal)
    echo
    echo (set_color --bold)"FURTHER DOCUMENTATION"(set_color normal)
    echo "      For more details and examples check out "(set_color --bold)https://github.com/joseluisq/gitnow/blob/master/README.md(set_color normal)
    echo
    echo (set_color --bold)"CONTRIBUTIONS"(set_color normal)
    echo "      Send bug reports or pull requests to "(set_color --bold)https://github.com/joseluisq/gitnow(set_color normal)
    echo
    echo (set_color --bold)"LICENSE"(set_color normal)
    echo "      GitNow licensed under the MIT License "(set_color --bold)https://github.com/joseluisq/gitnow/blob/master/LICENSE.md(set_color normal)
    echo
    echo (set_color --bold)"AUTHOR"(set_color normal)
    echo "      (c) 2016-present Jose Quintana "(set_color --bold)"https://git.io/joseluisq"(set_color normal)
    echo
end
