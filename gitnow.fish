# Commit and Push commands
function upstream -d "Add, commit and push commands"
  commit
  push
end

# `git add` and `git commit` for all changes on current branch
function commit -d "`git add` + `git commit`"
  git add -A
  git commit -S .
end

# git pull --rebase and git stash built-in
# Shortcut inspired from https://github.com/jamiew/git-friendly
function pull -d "git pull --rebase + git stash built-in"
  set -l stash (git stash)
  echo

  git stash
  eval (echo git pull --rebase (gargs $argv))
  echo

  if test "$stash" = "No local changes to save"
    echo "* No stashed changes, not popping."
  else
    echo "* Popping stash..."
    echo
    git stash pop
  end

  echo
end

# Git push with upstream
# Shortcut inspired from https://github.com/jamiew/git-friendly
function push -d "git push with upstream"
  echo
  set -l exit_code $status
  eval (echo git push --set-upstream (gargs $argv))

  if test $status -eq 0
    echo
    echo "Git says everything is up-to-date!"
  else
    echo
    echo -e "Ouch, push failed!"
  end

  echo
end

# git clone shortcut for Github repos
# Usages:
#  gh gh-repo-name
#  gh gh-username gh-repo-name
function gh -d "git clone shortcut for GitHub repos"
  set -l len (count $argv)
  set -l user (git config --global user.github)
  set -l repo ""
  set -l ecode 1

  if test $len -lt 1
    echo
    echo "Repository name is required!"
    echo '  gh gh-repo-name'
    echo
  else
    if test $len -gt 1
      set user $argv[1]
      set repo $argv[2]
    else
      set repo $argv[1]

      if test -z $user
        set ecode 0
      end
    end

    if test $ecode -eq 1
      gclone git@github.com:$user/$repo.git
    else
      echo
      echo "Username is required!"
      echo
      echo 'Usages:'
      echo '  a) gh gh-username gh-repo-name'
      echo
      echo '  b) gh gh-repo-name'
      echo '     It\'s necessary to set the Github login to global config before:'
      echo '     git config --global user.github "your-github-username"'
      echo
    end
  end
end

# Git clone shortcut
function gclone -d "Git clone shortcut"
  eval (echo git clone $argv)
end

# Processing and return the git arguments
function gargs -d "Processing the git arguments"
  set -l len (count $argv)
  set -l bran (git symbolic-ref --short HEAD ^/dev/null)
  set -l orig (git config "branch.$bran.remote"; or echo origin)

  if set -q argv
    if test $len -gt 0
      set orig $argv[1]
    end

    if test $len -gt 1
      set bran $argv[2]
    end
  end

  echo $orig $bran
end
