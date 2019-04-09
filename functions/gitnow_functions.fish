# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
# 
# NOTE:
#   Fish 2.2.0 doesn't include native snippet support.
#   Upgrade to Fish >= 2.3.0 or append the following code to your ~/.config/fish/config.fish

function _gitnow_new_branch_switch
  set -l branch_name $argv[1]

  if test (count $argv) -eq 1
    set branch_name $branch_name

    git checkout -b $branch_name
  else
    echo "Provide a branch name."
  end
end

# adapted from https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
function _gitnow_slugify
  echo $argv | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9]+/_/g' | sed -E 's/^(-|_)+|(-|_)+$//g' | tr A-Z a-z
end

function _gitnow_clone_repo
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
      _gitnow_clone_msg $platform
    end
  else
    _gitnow_clone_msg $platform
  end
end

function _gitnow_clone_msg
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

function _gitnow_check_if_branch_exist
  if test (count $argv) -eq 1
    set -l xbranch $argv[1]
    set -l xbranch_list (_gitnow_current_branch_list)
    set -l xfound 0

    for b in $xbranch_list
      if [ "$xbranch" = "$b" ]
        set xfound 1
        break
      end
    end

    echo $xfound
  else
    echo "Provide a valid branch name."
  end
end

function _gitnow_clone_params
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

function _gitnow_current_branch_name
  git symbolic-ref --short HEAD ^ /dev/null
end

function _gitnow_current_branch_list
  git branch --list --no-color | sed -E "s/^(\*?[ \t]*)//g" ^ /dev/null
end

function _gitnow_current_remote -d "Gitnow: Get current origin name"
  set -l branch_name (_gitnow_current_branch_name)
  git config "branch.$branch_name.remote"; or echo origin
end

function _gitnow_current_commit_short
  git rev-parse --short HEAD ^ /dev/null
end
