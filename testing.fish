#!/usr/bin/fish

# Archaic Fish shell error checks for GitNow,
# since that Fish shell doesn't support any "strict mode" like Bash.
# see https://github.com/fish-shell/fish-shell/issues/805

echo "Testing GitNow files..."

set -l out (fish -c 'source' 2>&1)

if test $status -gt 0
    echo "ERROR: Fish shell error signal was emitted!"
    exit $status
end

# This is ad-hoc string check
set -l err_str (echo $out | awk '$0 ~ /type: Unknown|fish: Unknown command:|source: Error/ {print $1}')

if test -n "$err_str"
    echo "ERROR: Fish shell parsing error has occurred!"
    exit 1
end

gitnow --version

echo "OK"
