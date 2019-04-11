# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
#
# NOTE:
#   Fish 2.2.0 doesn't include native snippet support.
#   Upgrade to Fish >= 2.3.0 or append the following code to your ~/.config/fish/config.fish

set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
set -q fish_config; or set -g fish_config $XDG_CONFIG_HOME/fish
set -q fish_functions; or set -g fish_functions "$fish_config/functions"

set -g gitnow_version 2.0.4

source "$fish_functions/__gitnow_functions.fish"
source "$fish_functions/__gitnow_manual.fish"
