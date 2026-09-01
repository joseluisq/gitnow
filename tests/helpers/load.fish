# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
#
# Test helper: load GitNow deterministically inside a FishTest process.
# Every *.test.fish starts with:
#
#     source (status dirname)/../helpers/load.fish
#
# It pins all config lookups to the shipped default so a developer's
# ~/.gitnow can't alter behavior and the v2 config loader's curl fallback
# can never fire (tests run fully offline).

set -g gitnow_test_root (path resolve (status dirname)/../..)

set -g fish_snippets $gitnow_test_root/conf.d
set -g GITNOW_CONFIG_FILE $gitnow_test_root/conf.d/.gitnow
set fish_function_path $gitnow_test_root/functions $fish_function_path

source $gitnow_test_root/conf.d/gitnow.fish
