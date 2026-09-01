# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

source (status dirname)/../helpers/load.fish

describe "__gitnow_slugify"

it "lowercases and underscores spaces"
expect "$(__gitnow_slugify "This is my New Branch")" --to-equal this_is_my_new_branch

it "lowercases uppercase input"
expect "$(__gitnow_slugify "My FEATURE")" --to-equal my_feature

it "transliterates unicode to ascii"
expect "$(__gitnow_slugify "Ñandú Café")" --to-equal nandu_cafe
expect "$(__gitnow_slugify "Ærøskøbing Straße Œuvre")" --to-equal aeroskobing_strasse_oeuvre
expect "$(__gitnow_slugify "ÀÉÎÕÜ")" --to-equal aeiou

it "maps other non-ascii characters to underscores"
expect "$(__gitnow_slugify "日本 x")" --to-equal x
expect "$(__gitnow_slugify "a→b")" --to-equal a_b

it "preserves slash and dot (valid in git refs)"
expect "$(__gitnow_slugify "Fix/v1.2")" --to-equal fix/v1.2

it "preserves hyphens"
expect "$(__gitnow_slugify "my-branch-01")" --to-equal my-branch-01

it "leaves already-valid input unchanged"
expect "$(__gitnow_slugify "feature/my_feature")" --to-equal feature/my_feature

it "does not let echo eat dash-prefixed args"
expect "$(__gitnow_slugify -n x)" --to-equal n_x

it "strips leading and trailing separators"
expect "$(__gitnow_slugify "__hello__")" --to-equal hello
expect "$(__gitnow_slugify "./hello")" --to-equal hello

it "collapses runs of invalid characters"
expect "$(__gitnow_slugify "a!!@@b")" --to-equal a_b

it "yields empty output for empty or separator-only input"
expect (__gitnow_slugify "") --to-be-empty
expect (__gitnow_slugify "___") --to-be-empty
