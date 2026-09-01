# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
#
# Covers the v2 `.gitnow` INI parser. Phase 4 replaces it with
# variable-based config (see plan/phase-4-config.md); update these then.

source (status dirname)/../helpers/load.fish

function setup_config_fixture
    set -g config_tmpdir (mktemp -d)
    set -g config_marker $config_tmpdir/marker
    set -g GITNOW_CONFIG_FILE $config_tmpdir/.gitnow
    touch $config_marker
end

function teardown_config_fixture
    rm -rf $config_tmpdir
end

before_all setup_config_fixture
after_all teardown_config_fixture

describe "__gitnow_load_config"

it "parses a valid config without error"
printf '%s\n' \
    '# a comment line' \
    '[ options ]' \
    'clipboard = false' \
    '' \
    '[ keybindings ]' \
    '# custom key for state' \
    'state = \co' \
    'commit-all = \cq' \
    '# not a gitnow command: must be ignored' \
    'rmrf = \cx' \
    "evil = \\cy; rm -rf $config_marker" \
    > $GITNOW_CONFIG_FILE
__gitnow_load_config
expect $status --to-succeed

it "binds a valid command to the configured key"
expect "$(bind ctrl-o 2>/dev/null)" --to-match 'state'
expect "$(bind ctrl-q 2>/dev/null)" --to-match 'commit-all'

it "never binds an unknown command"
expect "$(bind)" --not-to-match 'rmrf'

it "never binds or executes an injection attempt"
expect "$(bind)" --not-to-match 'evil'
expect $config_marker --to-exist

it "tolerates a garbage config"
echo '%%% total ((( garbage ]][[ = = =' > $GITNOW_CONFIG_FILE
__gitnow_load_config
expect $status --to-succeed

it "treats a missing custom config file as not an error"
set -g GITNOW_CONFIG_FILE $config_tmpdir/does-not-exist
__gitnow_load_config
expect $status --to-succeed
