# GitNow
> Speed up your Git workflow. :tropical_fish: + :octocat:

**gitnow** is a [Fish](https://fishshell.com/) alternative inspired by [git-friendly](https://github.com/jamiew/git-friendly) but with more pluses.

## Install

With [Fisher](https://github.com/jorgebucaran/fisherman):

```sh
fisher add joseluisq/gitnow
```

> __Note:__ Fish 2.2.0 doesn't include native snippet support. Upgrade to Fish >= 2.3.0 or append the `gitnow.fish` to your `~/.config/fish/config.fish` file.

## Commands

Command | Description
--- | ---
**state** | Show the working tree status in compact way.
**stage** | Stage files in current working directory.
**unstage** | Unstage files in current working directory.
**commit** | Commit changes to the repository.
**commit-all** | Add and commit all changes to the repository.
**pull** | Pull changes from remote server but saving uncommitted changes.
**push** | Push commit changes to remote repository.
**upstream** | Commit all changes and push them to remote server.
**github** | Clone a GitHub repository using SSH.
**bitbucket** | Clone a Bitbucket Cloud repository using SSH.

**Tips:**

- Skip the password request creating a SSH key for your [Github](https://help.github.com/en/articles/connecting-to-github-with-ssh) or [Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html) account.
- SSH setup is required for using `github` and `bitbucket` commands.

## Usage

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
push <origin_name> <branch_name>
```

### upstream

Commit all changes and push them to remote server.

__Note:__ This command does `commit-all` and then `push`. No flags supported.

```sh
upstream
```

### github

Clone a GitHub repository using SSH.

Examples:

```sh
github username/repo-name
github username repo-name
github repo-name # required a `user.github` username setted
```

### bitbucket

Clone a Bitbucket Cloud repository using SSH.

Examples:

```sh
github username/repo-name
github username repo-name
github repo-name # required a `user.bitbucket` username setted
```

__Note:__ For cloning some repo only, it's necessary to set your Github or Bitbucket username to global config before like:

```sh
# a) GitHub
git config --global user.github \"your-username\"
# b) Bitbucket
git config --global user.bitbucket \"your-username\"
```

## Contributions

[Pull requests](https://github.com/joseluisq/gitnow/pulls) and [issues](https://github.com/joseluisq/gitnow/issues) are welcome.

## License
MIT license

© 2016-present [Jose Quintana](http://git.io/joseluisq)
