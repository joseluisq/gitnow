# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

set -g gitnow_version 2.10.0

if set -q __fish_config_dir
    set -g fish_config "$__fish_config_dir"
else
    set -q XDG_CONFIG_HOME
        and set -g fish_config "$XDG_CONFIG_HOME/fish"
        or set -g fish_config "~/.config/fish"
end

set -q fish_snippets; or set -g fish_snippets "$fish_config/conf.d"
set -q fish_functions; or set -g fish_functions "$fish_config/functions"
set -q fish_completions; or set -g fish_completions "$fish_config/completions"
set -q GITNOW_CONFIG_FILE; or set -g GITNOW_CONFIG_FILE ~/.gitnow

if functions -q __fundle_plugins_dir
    set -l fundledir (__fundle_plugins_dir)
    source "$fundledir/joseluisq/gitnow/functions/__gitnow_functions.fish"
    source "$fundledir/joseluisq/gitnow/functions/__gitnow_manual.fish"
    source "$fundledir/joseluisq/gitnow/functions/__gitnow_config_file.fish"
    source "$fundledir/joseluisq/gitnow/completions/__gitnow_completions.fish"
else
    source "$fish_functions/__gitnow_functions.fish"
    source "$fish_functions/__gitnow_manual.fish"
    source "$fish_functions/__gitnow_config_file.fish"
    source "$fish_completions/__gitnow_completions.fish"
end

__gitnow_read_config
