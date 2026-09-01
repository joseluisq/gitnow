# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
#
# Offline integration suite: exercises the public commands against a local
# bare "origin" inside a mktemp sandbox. No network, no writes outside the
# sandbox. This is the v2-behavior baseline that the v3 refactor phases must
# preserve (see plan/phase-2-tests-ci.md).

source (status dirname)/../helpers/load.fish

function setup_sandbox
    set -g sandbox (mktemp -d)
    set -g origin $sandbox/origin.git

    command git init -q --bare $origin
    command git -C $sandbox clone -q "file://$origin" work 2>/dev/null
    cd $sandbox/work

    command git config user.email gitnow@test.local
    command git config user.name "GitNow Test"
    command git config commit.gpgsign false
    command git checkout -q -b master

    # Non-interactive editor: writes a fixed message (used by commit-all)
    set -gx GIT_EDITOR 'echo test-commit >'
end

function teardown_sandbox
    cd /
    command rm -rf $sandbox
end

function current_branch
    command git symbolic-ref --short HEAD
end

before_all setup_sandbox
after_all teardown_sandbox

describe "state / stage / unstage / untracked"

it "state exits 0"
state >/dev/null 2>&1
expect $status --to-succeed

it "untracked lists a stray file"
echo hello > readme.md
untracked >/dev/null 2>&1
expect $status --to-succeed
expect (untracked 2>&1) --to-match 'readme\.md'

it "stage stages the file"
stage readme.md >/dev/null 2>&1
expect $status --to-succeed
expect (command git status --porcelain) --to-equal "A  readme.md"

it "unstage clears the index"
unstage >/dev/null 2>&1
expect $status --to-succeed
expect (command git status --porcelain) --to-equal "?? readme.md"

describe "commit / commit-all / push"

it "commit -m creates a commit"
stage >/dev/null 2>&1
commit -m init >/dev/null 2>&1
expect $status --to-succeed
expect (command git rev-list --count HEAD) --to-equal 1

it "commit-all stages and commits everything"
echo more >> readme.md
commit-all >/dev/null 2>&1
expect $status --to-succeed
expect (command git rev-list --count HEAD) --to-equal 2

it "push sets upstream and delivers to origin"
push >/dev/null 2>&1
expect $status --to-succeed
expect (command git -C $origin rev-parse master) --to-equal (command git rev-parse HEAD)

describe "branch"

it "slugifies the branch name"
branch "My Branch" >/dev/null 2>&1
expect $status --to-succeed
expect (current_branch) --to-equal my_branch

it "reports an existing branch"
expect (branch "My Branch" 2>&1) --to-match 'already exists'

it "rejects an empty branch name"
expect (branch "" 2>&1) --to-match 'required'

it "keeps slash hierarchy and dots"
branch "Feat/Login.Page" >/dev/null 2>&1
expect (current_branch) --to-equal feat/login.page

describe "gitflow branches"

it "feature creates a lowercase prefixed branch"
feature "My FEATURE" >/dev/null 2>&1
expect (current_branch) --to-equal feature/my_feature

it "hotfix creates a prefixed branch"
hotfix "Hot Fix 1" >/dev/null 2>&1
expect (current_branch) --to-equal hotfix/hot_fix_1

describe "move"

it "auto-stashes and re-applies uncommitted changes"
echo dirty >> readme.md
move master >/dev/null 2>&1
expect $status --to-succeed
expect (current_branch) --to-equal master
expect (command cat readme.md) --to-contain dirty

it "returns to the previous branch with -"
move my_branch >/dev/null 2>&1
move - >/dev/null 2>&1
expect (current_branch) --to-equal master
# Baseline quirk: bare `move -` delegates to `move -n`, so with a dirty
# tree it leaves the auto-stash unapplied on purpose.

it "keeps the stash unapplied with -n"
command git checkout -q -- . 2>/dev/null
echo dirty2 >> readme.md
set -l pre_stash (command git stash list | count)
move -n my_branch >/dev/null 2>&1
expect (current_branch) --to-equal my_branch
expect (command git stash list | count) --to-equal (math $pre_stash + 1)
command git stash clear 2>/dev/null
move master >/dev/null 2>&1

describe "merge"

it "merges a topic branch into the current branch"
branch topic >/dev/null 2>&1
echo topic-work > topic.txt
stage >/dev/null 2>&1
commit -m "topic work" >/dev/null 2>&1
move master >/dev/null 2>&1
merge topic >/dev/null 2>&1
expect $status --to-succeed
expect (command cat topic.txt) --to-equal topic-work

it "rejects a missing branch"
expect (merge nope 2>&1 | string lower) --to-match 'not.*found'

describe "show / logs"

it "show exits 0"
show >/dev/null 2>&1
expect $status --to-succeed

it "logs exits 0"
logs >/dev/null 2>&1
expect $status --to-succeed

describe "tag"

it "creates the first patch tag"
tag -z >/dev/null 2>&1
expect (command git tag --list v0.0.1) --to-equal v0.0.1

it "bumps minor past v10 (multi-digit components)"
command git tag v10.9.9
tag -y >/dev/null 2>&1
expect (command git tag --list v10.10.0) --to-equal v10.10.0

it "bumps patch past v10"
tag -z >/dev/null 2>&1
expect (command git tag --list v10.10.1) --to-equal v10.10.1

it "bumps major"
tag -x >/dev/null 2>&1
expect (command git tag --list v11.0.0) --to-equal v11.0.0

it "lists the latest tags with -l"
expect (tag -l 2>&1) --to-match 'v11\.0\.0'

describe "assume"

it "marks a file as assume-unchanged"
assume readme.md >/dev/null 2>&1
expect $status --to-succeed
expect (command git ls-files -v readme.md) --to-match '^h '

it "unmarks it with -n"
assume -n readme.md >/dev/null 2>&1
expect (command git ls-files -v readme.md) --to-match '^H '
