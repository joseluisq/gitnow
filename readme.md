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

`pull`, `push`, `commit` and `upstream` support git arguments. For example: `push origin --tags` or `pull origin --tags`

Command | Description
--- | ---
**pull** | Equivalent to `git stash` and `git pull --rebase` (--rebase option is used only if repository was not rebased yet)
**push** | Equivalent to `git push`
**commit** | Equivalent to `git add -A` and `git commit .`
**upstream** | Equivalent to `commit` and `push` commands. `-S` (optional) for GPG-sign commit.
**gh** | `git clone` shortcut for Github repositories.

### **gh**
You can try these alternatives:

- `gh username/repo`
- `gh username repo`
- `gh repo` : It's necessary to set your Github username (globaly). For this works, type: `git config --global user.github "your-github-username"`

**Tip:** Skip the password request creating a SSH key for your Github or Bitbucket account.

## Contributions

[Pull requests](https://github.com/joseluisq/gitnow/pulls) and [issues](https://github.com/joseluisq/gitnow/issues) are welcome.

## License
MIT license

© 2016 [José Luis Quintana](http://git.io/joseluisq)
