# Fish 2.2.0 doesn't include native snippet support.
# Upgrade to Fish >= 2.3.0 or append the following code
# to your ~/.config/fish/config.fish

function state -d "Gitnow: Show the working tree status in compact way"
  echo "Current working tree status:"
  git status -sb
end

function stage -d "Gitnow: Stage files in current working directory"
  set -l len (count $argv)
  set -l opts .

  if test $len -gt 0
    set opts $argv
  end

  git add $opts
end

function unstage -d "Gitnow: Unstage files in current working directory"
  set -l len (count $argv)
  set -l opts .

  if test $len -gt 0
    set opts $argv
  end

  git reset $opts
end

function commit -d "Gitnow: Commit changes to the repository"
  set -l len (count $argv)

  if test $len -gt 0
    git commit $argv
  else
    git commit
  end
end

function commit-all -d "Gitnow: Add and commit all changes to the repository"
  stage
  commit .
end

function pull -d "Gitnow: Pull changes from remote server but saving uncommitted changes"
  set -l len (count $argv)
  set -l xorigin (__gitnow_current_remote)
  set -l xbranch (__gitnow_current_branch_name)
  set -l xcmd ""
  
  echo "📥 Pulling changes"

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
function push -d "Gitnow: Push commit changes to remote repository"
  set -l bran (__gitnow_current_branch_name)
  set -l orig (__gitnow_current_remote)
  set -l comi (__gitnow_current_commit_short)
  set -l opts $argv

  echo "📤 Pushing changes"

  if test (count $argv) -eq 0
    set opts $orig $bran
  end

  set -l pushr (git push --set-upstream $opts 2>&1)

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

function upstream -d "Gitnow: Commit all changes and push them to remote server"
  commit-all
  push
end

function github -d "Gitnow: Clone a GitHub repository using SSH"
  set -l repo (__gitnow_clone_params $argv)
  __gitnow_clone_repo $repo "github"
end

function bitbucket -d "Gitnow: Clone a Bitbucket Cloud repository using SSH"
  set -l repo (__gitnow_clone_params $argv)
  __gitnow_clone_repo $repo "bitbucket"
end

function __gitnow_clone_repo
  set -l repo $argv[1]
  set -l platform $argv[2]

  if test -n "$repo"
    set -l ok 1

    if echo $repo | grep -q -E '^[\%S].+'
      set -l user (git config --global user.$platform)

      if test -n "$user"
        set -l repor (echo $repo | sed -e "s/^%S/$user/")
        set repo $repor
      else
        set ok 0
      end
    end

    if test $ok -eq 1
      if [ "$platform" = "github" ]
        set url github.com
      end

      if [ "$platform" = "bitbucket" ]
        set url bitbucket.org
      end

      set -l repo_url git@$url:$repo.git
      
      echo "📦 Remote repository: $repo_url"
      git clone $repo_url
    else
      __gitnow_clone_msg $platform
    end
  else
    __gitnow_clone_msg $platform
  end
end

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

function __gitnow_clone_params
  set -l repo

  if count $argv > /dev/null
    if test (count $argv) -gt 1
      set repo $argv[1]/$argv[2]
    else if echo $argv | grep -q -E '^([a-zA-Z0-9\_\-]+)\/([a-zA-Z0-9\_\-]+)$'
      set repo $argv
    else
      set repo "%S/$argv"
    end
  end

  echo $repo
end

function __gitnow_args -d "Gitnow: Processing the git arguments"
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

function __gitnow_current_branch_name -d "Gitnow: Get current branch name"
  git symbolic-ref --short HEAD ^/dev/null
end

function __gitnow_current_remote -d "Gitnow: Get current origin name"
  set -l branch_name (__gitnow_current_branch_name)
  git config "branch.$branch_name.remote"; or echo origin
end

function __gitnow_current_path -d "Gitnow: Get current git path repository"
  git rev-parse --show-toplevel ^ /dev/null
end

function __gitnow_is_git_repository -d "Gitnow: Checks if the current path is a git path"
  git rev-parse --git-dir ^ /dev/null
end

function __gitnow_current_commit_short -d "Gitnow: Get current commit in short format"
  git rev-parse --short HEAD ^ /dev/null
end
