# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
# 
# NOTE:
#   Fish 2.2.0 doesn't include native snippet support.
#   Upgrade to Fish >= 2.3.0 or append the following code to your ~/.config/fish/config.fish

function state -d "Gitnow: Show the working tree status in compact way"
  echo "Current working tree status:"
  git status -sb
  commandline -f repaint;
end

function stage -d "Gitnow: Stage files in current working directory"
  set -l len (count $argv)
  set -l opts .

  if test $len -gt 0
    set opts $argv
  end

  git add $opts
  commandline -f repaint;
end

function unstage -d "Gitnow: Unstage files in current working directory"
  set -l len (count $argv)
  set -l opts .

  if test $len -gt 0
    set opts $argv
  end

  git reset $opts
  commandline -f repaint;
end

function commit -d "Gitnow: Commit changes to the repository"
  set -l len (count $argv)

  if test $len -gt 0
    git commit $argv
  else
    git commit
  end

  commandline -f repaint;
end

function commit-all -d "Gitnow: Add and commit all changes to the repository"
  stage
  commit .
end

function pull -d "Gitnow: Pull changes from remote server but saving uncommitted changes"
  set -l len (count $argv)
  set -l xorigin (_gitnow_current_remote)
  set -l xbranch (_gitnow_current_branch_name)
  set -l xcmd ""
  
  echo "📥 Pulling changes..."

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
  commandline -f repaint;
end

# Git push with --set-upstream
# Shortcut inspired from https://github.com/jamiew/git-friendly
function push -d "Gitnow: Push commit changes to remote repository"
  set -l bran (_gitnow_current_branch_name)
  set -l orig (_gitnow_current_remote)
  set -l comi (_gitnow_current_commit_short)
  set -l opts $argv

  echo "📤 Pushing changes..."

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
  commandline -f repaint;
end

function upstream -d "Gitnow: Commit all changes and push them to remote server"
  commit-all
  push
end

function feature -d "GitNow: Creates a new feature (Gitflow) branch from current branch"
  set -l xprefix "feature"
  set -l xbranch (_gitnow_slugify $argv[1])
  set -l xbranch_full "$xprefix/$xbranch"
  set -l xfound (_gitnow_check_if_branch_exist $xbranch_full)

  if test $xfound -eq 1
    echo "Branch `$xbranch_full` already exists. Nothing to do."
  else
    git stash
    _gitnow_new_branch_switch "$xbranch_full"
    git stash pop
  end

  commandline -f repaint;
end

function hotfix -d "GitNow: Creates a new hotfix (Gitflow) branch from current branch"
  set -l xprefix "hotfix"
  set -l xbranch (_gitnow_slugify $argv[1])
  set -l xbranch_full "$xprefix/$xbranch"
  set -l xfound (_gitnow_check_if_branch_exist $xbranch_full)

  if test $xfound -eq 1
    echo "Branch `$xbranch_full` already exists. Nothing to do."
  else
    git stash
    _gitnow_new_branch_switch "$xbranch_full"
    git stash pop
  end

  commandline -f repaint;
end

function move -d "GitNow: Switch from current branch to another but stashing uncommitted changes"
  if test (count $argv) -gt 0
    set -l xbranch $argv[1]
    set -l xfound (_gitnow_check_if_branch_exist $xbranch)

    if test $xfound -eq 1
      git stash
      git checkout $xbranch
      git stash pop
    else
      echo "Branch `$xbranch` was not found. No possible to switch."
    end
  else
    echo "Provide a branch name to move."
  end

  commandline -f repaint;
end

function github -d "Gitnow: Clone a GitHub repository using SSH"
  set -l repo (_gitnow_clone_params $argv)
  _gitnow_clone_repo $repo "github"

  commandline -f repaint;
end

function bitbucket -d "Gitnow: Clone a Bitbucket Cloud repository using SSH"
  set -l repo (_gitnow_clone_params $argv)
  _gitnow_clone_repo $repo "bitbucket"

  commandline -f repaint;
end

function gitnow -d "Gitnow: Speed up your Git workflow. 🐠"
  _gitnow_manual | less -r

  commandline -f repaint;
end
