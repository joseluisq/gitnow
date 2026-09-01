# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

source (status dirname)/../helpers/load.fish

describe "__gitnow_get_valid_semver_release_value"

it "extracts a version with v prefix"
expect "$(__gitnow_get_valid_semver_release_value v1.2.3)" --to-equal 1.2.3

it "extracts a version without prefix"
expect "$(__gitnow_get_valid_semver_release_value 1.2.3)" --to-equal 1.2.3

it "extracts multi-digit components"
expect "$(__gitnow_get_valid_semver_release_value v10.20.30)" --to-equal 10.20.30

it "extracts the base of a prerelease tag"
expect "$(__gitnow_get_valid_semver_release_value v1.2.3-rc.1)" --to-equal 1.2.3

it "rejects garbage"
expect (__gitnow_get_valid_semver_release_value foobar) --to-be-empty

it "rejects a partial version"
expect (__gitnow_get_valid_semver_release_value v1.2) --to-be-empty

it "rejects empty input"
expect (__gitnow_get_valid_semver_release_value "") --to-be-empty

it "rejects non-numeric components"
expect (__gitnow_get_valid_semver_release_value v1.a.3) --to-be-empty
