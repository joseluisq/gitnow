# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
set -q fish_config; or set -g fish_config $XDG_CONFIG_HOME/fish
set -q fish_snippets; or set -g fish_snippets "$fish_config/conf.d"
set -q fish_functions; or set -g fish_functions "$fish_config/functions"
set -q GITNOW_CONFIG_FILE; or set -g GITNOW_CONFIG_FILE ~/.gitnow

set -g gitnow_version 2.3.0

source "$fish_functions/__gitnow_functions.fish"
source "$fish_functions/__gitnow_manual.fish"
source "$fish_functions/__gitnow_config_file.fish"

__gitnow_read_config
