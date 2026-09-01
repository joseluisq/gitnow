# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

source (status dirname)/../helpers/load.fish

describe "__gitnow_increment_number"

it "increments zero"
expect "$(__gitnow_increment_number 0)" --to-equal 1

it "increments a single digit"
expect "$(__gitnow_increment_number 9)" --to-equal 10

it "increments multiple digits"
expect "$(__gitnow_increment_number 99)" --to-equal 100

describe "__gitnow_is_number"

it "accepts an integer"
__gitnow_is_number 42
expect $status --to-succeed

it "accepts zero"
__gitnow_is_number 0
expect $status --to-succeed

it "rejects alphabetic input"
__gitnow_is_number abc
expect $status --to-fail

it "rejects mixed input"
__gitnow_is_number 4a2
expect $status --to-fail

it "rejects a negative number (sign not allowed)"
__gitnow_is_number -1
expect $status --to-fail

it "rejects empty input"
__gitnow_is_number ""
expect $status --to-fail
