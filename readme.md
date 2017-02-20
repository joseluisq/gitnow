# gitnow
> Simple and fast commands for your git workflow. :tropical_fish: + :octocat:

_**gitnow** is a [Fish](https://fishshell.com/) alternative  inspired by [git-friendly](https://github.com/jamiew/git-friendly)._

## Install

With [fisherman](https://github.com/fisherman/fisherman)

```sh
fisher joseluisq/gitnow
```

*__Note:__ Fish 2.2.0 doesn't include native snippet support. Upgrade to Fish >= 2.3.0 or append the `gitnow.fish` to your `~/.config/fish/config.fish` file.*

## CLI

Command | Description
--- | ---
**commit** | Equivalent to `git add -A ; git commit [your arguments...]`.
**pull** | Equivalent to `git stash ; git pull --rebase [your arguments...]` (--rebase option is used only if repository was not rebased yet).
**push** | Equivalent to `git push --set-upstream [your arguments...]`.
**upstream** | Equivalent to `commit ; push` commands. (`-S` is optional for GPG-sign commits)
**gh** | Equivalent to `git clone` for Github repositories.

_`pull`, `push` and `commit` support git arguments._

> **Tip:** :bulb: Skip the password request creating a SSH key for your Github or Bitbucket account.

#### commit
`commit` adds all files `git addd .` and then it performs `git commit`.

Examples:
```sh
commit
commit -S
commit . -m "my awesome commit"
```

#### pull

`pull` saves your local changes with `git stash` and then it performs `git pull --rebase`.

Examples:
```sh
pull
pull my_origin my_branch
pull my_origin --tags
```

#### push
`push` contains `--set-upstream` option by default.

Examples:
```sh
push
push my_origin my_branch
push my_origin --tags
```

#### upstream
Equivalent to `commit ; push` commands. Very useful for send your changes quickly. 

Examples:
```sh
upstream
upstream -S
```

#### **gh**
`git clone` shortcut for Github repositories.

Examples:

- `gh username/repo`
- `gh username repo`
- `gh repo` : It's necessary to set your Github username (globaly). For this works, type: `git config --global user.github "your-github-username"`

_**Note:** You need a [SSH key for your Github account](https://help.github.com/articles/connecting-to-github-with-ssh/)._

## Contributions

[Pull requests](https://github.com/joseluisq/gitnow/pulls) and [issues](https://github.com/joseluisq/gitnow/issues) are welcome.

## License
MIT license

© 2016 [José Luis Quintana](http://git.io/joseluisq)
