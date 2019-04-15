# GitNow [![Build Status](https://travis-ci.org/joseluisq/gitnow.svg?branch=master)](https://travis-ci.org/joseluisq/gitnow) [![Releases](https://img.shields.io/github/release/joseluisq/gitnow.svg?label=latest)](https://github.com/joseluisq/gitnow/releases)

> Speed up your Git workflow. 🐠

GitNow contains a command set that provides high-level operations on the top of Git. A Fish shell alternative inspired by [git-friendly](https://github.com/jamiew/git-friendly).

## Install

With [Fisher](https://github.com/jorgebucaran/fisherman):

__Stable:__

```sh
fisher add joseluisq/gitnow@2.0.5
```

<small>_**Note:** Replace the number above with your preferred release._</small>

__Ustable:__

```sh
fisher add joseluisq/gitnow
```

## Commands

- [gitnow](#gitnow) — Show available commands and version info.
- [state](#state) — Show the working tree status in a compact way.
- [stage](#stage) — Stage files in current working directory.
- [unstage](#unstage) — Unstage files in current working directory.
- [commit](#commit) — Commit changes to the repository.
- [commit-all](#commit-all) — Add and commit all changes to the repository.
- [pull](#pull) — Pull changes from remote server but saving uncommitted changes.
- [push](#push) — Push commit changes to remote repository.
- [upstream](#upstream) — Commit all changes and push them to remote server.
- [move](#move) — Moves from current branch to another but stashing your changes.
- [feature](#feature) — Creates a new _feature_ ([Gitflow](https://github.com/nvie/gitflow)) branch from current branch.
- [hotfix](#hotfix) — Creates a new _hotfix_ ([Gitflow](https://github.com/nvie/gitflow)) branch from current branch.
- [logs](#logs) — Shows logs in a fancy way.
- [github](#github) — Clone a _GitHub_ repository using SSH.
- [bitbucket](#bitbucket) — Clone a _Bitbucket Cloud_ repository using SSH.

**Tips:**

- Skip the password request creating a SSH key for your [Github](https://help.github.com/en/articles/connecting-to-github-with-ssh) or [Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html) account.
- SSH setup is required for using `github` and `bitbucket` commands.
- Take adventage of [keybindings](#keybindings) in order to get faster operations.

## Keybindings

| Command      | Shortcut  |
| ------------- |:-------------:|
| state        |  Alt + S  |
| stage        |  Alt + E  |
| unstage      |  Ctrl + E |
| commit-all   |  Alt + C  |
| pull         |  Alt + D  |
| push         |  Alt + P  |
| upstream     |  Alt + U  |
| feature (1)  |  Alt + F  |
| hotfix (1)   |  Alt + H  |
| logs         |  Alt + L  |

_(1) This command key binding will creates a new branch taking as name some text of the clipboard._

## Usage

### gitnow

Show available commands and version info.

```sh
gitnow
```

### state

Show the working tree status in compact way.

```sh
state
Current working tree status:
## master...origin/master
 M README.md
 M conf.d/gitnow.fish
```

### stage

Stage files in current working directory.

__Note:__ This command does `git add .` by default. Add your `git add` flags as usual to overwrite it.

```sh
# a) git add . (by default)
stage
# b) custom 1
stage README.md LICENSE.md
# c) custom 2
stage . --ignore-errors
```

### unstage

Unstage files in current working directory.

__Note:__ This command does `git reset .` by default. Add your `git reset` flags as usual to overwrite it.

```sh
# a) git reset . (by default)
unstage
# b) custom 1
unstage README.md LICENSE.md
# c) custom 2
unstage --soft HEAD
```

### commit

Commit changes to the repository.

__Note:__ This command does `git commit` only. Add your `git commit` flags as usual to overwrite it.

```sh
commit
commit README.md
commit .
commit --amend
```

### commit-all

Add and commit all changes to the repository.

__Note:__ This command does `stage` and then `commit .`. No flags supported.

```sh
# stage && commit .
commit-all
```

### pull

Pull changes from remote server but saving uncommitted changes.

This command makes this for you:

- Save your uncommitted changes locally using `--autostash` option.
- Local changes you made will be rebased (`---rebase` option) on top of the remote changes.
- Return your uncommitted changes locally again.

__Auto mode:__

- `pull`
- `pull <branch_name>`
- `pull <remote_origin> <branch_name>`

__Manual mode:__

- `pull <remote_origin> <branch_name> --verbose`

```sh
pull
📥 Pulling changes
Arguments mode: Auto
Default arguments: --rebase --autostash
Remote: origin (https://github.com/joseluisq/gitnow.git)
Branch: master

From https://github.com/joseluisq/gitnow
 * branch            master     -> FETCH_HEAD
Created autostash: 473315a
HEAD is now at 9de2f93 update commands
Current branch master is up to date.
Applied autostash.
```

### push

Push commit changes to remote repository.

__Note:__ This command is equivalent to `git push --set-upstream [your arguments...]`.

```sh
# Auto mode (current origin and branch)
push
# Manual mode
push <origin_name> <branch_name> <--some_other_flags>
```

### upstream

Commit all changes and push them to remote server.

__Note:__ This command does `commit-all` and then `push`. No flags supported.

```sh
upstream
```

### move

Switch from current branch to another but stashing uncommitted changes

__Note:__ This command does `git stash` then `git checkout <other_branch>` and finally `git stash pop`. 
It also will make sure first that `<other_branch>` matchs with your existing branches. Use also `-u` (or `--upstream`) flag to fetch a remote branch.

```sh
move other_branch

# Branch `ghost_branch` was not found. No possible to switch.
move ghost_branch

# With -u flag the branch will be fetched from remote origin
move -u feature/new_remote_branch
```

### feature

Creates a new feature ([Gitflow](https://github.com/nvie/gitflow)) branch from current branch.

__Note:__ Your new branch will always be lowercase without special or whitespaces (underscores instead).

```sh
feature feat1
# > feature/feat1
feature "This is my New FEATURE Branch"
# > feature/this_is_my_new_feature_branch
```

### hotfix

Creates a new hotfix ([Gitflow](https://github.com/nvie/gitflow)) branch from current branch.

__Note:__ Your new branch will always be lowercase without special or whitespaces (underscores instead).

```sh
hotfix fix1
# > hotfix/fix1
hotfix "This is my New FIX Branch"
# > hotfix/this_is_my_new_fix_branch
```

### logs

Shows logs in a fancy way.

__Note:__ This command does `git log HEAD` by default using a pretty format. Add your `git log` flags as usual to overwrite it.

```sh
# shows all logs (default)
logs

# shows logs using git log parameters and flags (custom)
logs 8b09088
logs --before "yesterday" --after="1 week ago"
```

### github

Clone a GitHub repository using SSH.

Examples:

```sh
github username/repo-name
github username repo-name
github repo-name # requires a `user.github` username setted
```

### bitbucket

Clone a Bitbucket Cloud repository using SSH.

Examples:

```sh
bitbucket username/repo-name
bitbucket username repo-name
bitbucket repo-name # requires a `user.bitbucket` username setted
```

__Note:__ For cloning some repo only, it's necessary to set your Github or Bitbucket username to global config before like:

```sh
# a) GitHub
git config --global user.github "your_username"
# b) Bitbucket
git config --global user.bitbucket "your_username"
```

## Bonus

- [Git Cheat Sheet](https://github.com/joseluisq/git-cheat-sheet/) — Another Git cheat sheet yet.
- [Git useful aliases](https://github.com/joseluisq/git-useful-aliases) — Set of useful Git aliases.
- [Gitflow](https://github.com/nvie/gitflow)

## Contributions

[Pull requests](https://github.com/joseluisq/gitnow/pulls) and [issues](https://github.com/joseluisq/gitnow/issues) are welcome.

## License
MIT license

© 2016-present [Jose Quintana](http://git.io/joseluisq)
