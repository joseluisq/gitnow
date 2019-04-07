# Fish 2.2.0 doesn't include native snippet support.
# Upgrade to Fish >= 2.3.0 or append the following code
# to your ~/.config/fish/config.fish

# "Commit" and "Push --set-upstream" commands
function upstream -d "Add, commit and push commands"
  set -l S ""

  if test (count $argv) -eq 1
    if test "$argv[1]" = "-S"
      set S "-S"
    end
  end

  commit $S
  push
end

# `git add` and `git commit` for all changes on current branch
function commit -d "`git add` + `git commit`"
  git add -A
  git commit $argv
end

function pull -d "Gitnow: Pull changes from remote server but saving uncommitted changes"
  set -l len (count $argv)
  set -l xorigin (__gitnow_current_remote)
  set -l xbranch (__gitnow_current_branch_name)
  set -l xcmd ""
  
  echo "Pulling"

  set -l xdefaults --rebase --autostash

  if test $len -gt 2 
    set xcmd $argv

    echo "Arguments mode: Manual"
    echo "Default arguments: $xdefaults"
    echo
  else
    echo "Arguments mode: Auto"
    echo "Default arguments: $xdefaults"

    if test $len -eq 1
      set xbranch $argv[1]
    end

    if test $len -eq 2
      set xorigin $argv[1]
      set xbranch $argv[2]
    end

    set xcmd $xorigin $xbranch
    set -l xremote (git config --get "remote.$xorigin.url")

    echo "Remote: $xorigin ($xremote)"
    echo "Branch: $xbranch"
    echo
  end

  git pull $xcmd $xdefaults
end

# Git push with --set-upstream
# Shortcut inspired from https://github.com/jamiew/git-friendly
function push -d "git push"
  set -l bran (__gitnow_current_branch_name)
  set -l orig (__gitnow_current_remote)
  set -l comi (__gitnow_current_commit_short)
  set -l opts $argv

  if test (count $argv) -eq 0
    set opts $orig $bran
  end

  set -l pushr (git push -u $opts 2>&1)

  if test $status -eq 0
    echo

    if echo $pushr | grep -q -E 'Everything up\-to\-date'
      echo "🍺 Git says everything is up-to-date!"
    else
      echo "🚀 Your remote refs ('$orig/$bran') was updated! ($comi)"
    end
  else
    echo
    echo "⚠ Ouch, push failed!"
    echo -e $pushr
  end

  echo
end

# git clone shortcut for Github repos
function gh -d "git clone shortcut for GitHub repos"
  set -l repo

  if count $argv > /dev/null
    if test (count $argv) -gt 1
      set repo $argv[1]/$argv[2]
    else if echo $argv | grep -q -E '^([a-zA-Z0-9\_\-]+)\/([a-zA-Z0-9\_\-]+)$'
      set repo $argv
    else
      set -l user (git config --global user.github)
      set repo $user/$argv
    end

    __gitnow_clone git@github.com:$repo.git
  else
    echo
    echo "Repository name is required!"
    echo "E.g: gh your-repo-name"
    echo
    echo "Usages:"
    echo
    echo "  a) gh username/repo-name"
    echo "  b) gh username repo-name"
    echo "  c) gh repo-name"
    echo "     For this, it's necessary to set your Github username (login)"
    echo "     to global config before. You can type: "
    echo "     git config --global user.github \"your-github-username\""
    echo
  end
end

function __gitnow_clone -d "Git clone shortcut"
  eval (echo git clone $argv)
end

function __gitnow_args -d "Processing the git arguments"
  set -l len (count $argv)
  set -l bran (__gitnow_current_branch_name)
  set -l orig (__gitnow_current_remote)

  if set -q argv
    if test $len -gt 0
      set orig $argv[1]
    end

    if test $len -gt 1
      set bran $argv[2]
    end
  end

  echo -n $orig $bran
end

function branch -d "Get branch operations"
  set -l bran (__gitnow_current_branch_name)

  if test (count $argv) -eq 1
    set bran $argv[1]
  end

  git checkout $bran
end

function __gitnow_current_branch_name -d "Get current branch name"
  git symbolic-ref --short HEAD ^/dev/null
end

function __gitnow_current_remote -d "Get current origin name"
  set -l branch_name (__gitnow_current_branch_name)
  git config "branch.$branch_name.remote"; or echo origin
end

function __gitnow_current_path -d "Get current git path repository"
  git rev-parse --show-toplevel ^ /dev/null
end

function __gitnow_is_git_repository -d "Checks if the current path is a git path"
  git rev-parse --git-dir ^ /dev/null
end

function __gitnow_current_commit_short -d "Get current commit in short format"
  git rev-parse --short HEAD ^ /dev/null
end
