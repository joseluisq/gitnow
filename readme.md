# gitnow
> Simple and fast commands for your git workflow. :tropical_fish: + :octocat:

_**gitnow** is a [Fish](https://fishshell.com/) alternative  inspired by [git-friendly](https://github.com/jamiew/git-friendly)._

### Install

With [fisherman](https://github.com/fisherman/fisherman)

```sh
fisher joseluisq/gitnow
```

*__Note:__ Fish 2.2.0 doesn't include native snippet support. Upgrade to Fish >= 2.3.0 or append the `gitnow.fish` to your `~/.config/fish/config.fish` file.*

### Commands
Simply type some these commands:

- **pull** : *`git stash` and `git pull --rebase`*
- **push** :  *`git push --set-upstream`*
- **commit** : *`git add -A` and `git commit .`*
- **upstream** : *`commit` and `push` commands. `-S` option for GPG-sign commit.*
- **gh** : *`git clone` shortcut for Github repos.*
  - *Usage: `gh gh-repo-name` or `gh gh-username gh-repo-name`*

_**Tip:** For example, you could create an SSH key in your Github or Bitbucket account for skip the password request._

### Contributions

[Pull requests](https://github.com/joseluisq/gitnow/pulls) and [issues](https://github.com/joseluisq/gitnow/issues) are welcome.

### License
MIT license

© 2016 [José Luis Quintana](http://git.io/joseluisq)
