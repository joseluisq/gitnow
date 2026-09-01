# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_slugify -d "Turns free text into a git-safe, lowercase branch slug"
    # Pure Fish, no iconv: `iconv //TRANSLIT` is GNU-only in practice (macOS
    # iconv rejects or drops accented characters). Transliterate the common
    # Latin accents by hand, lowercase, then map anything else non-ASCII to
    # `_`. `/` and `.` are preserved since they are valid in branch names.
    set -l s (string join ' ' -- $argv)

    set s (string replace -ra '[àáâäãåāÀÁÂÄÃÅĀ]' a -- $s)
    set s (string replace -ra '[èéêëēÈÉÊËĒ]' e -- $s)
    set s (string replace -ra '[ìíîïīÌÍÎÏĪ]' i -- $s)
    set s (string replace -ra '[òóôöõøōÒÓÔÖÕØŌ]' o -- $s)
    set s (string replace -ra '[ùúûüūÙÚÛÜŪ]' u -- $s)
    set s (string replace -ra '[ýÿÝŸ]' y -- $s)
    set s (string replace -ra '[ñÑ]' n -- $s)
    set s (string replace -ra '[çÇ]' c -- $s)
    set s (string replace -ra '[ß]' ss -- $s)
    set s (string replace -ra '[æÆ]' ae -- $s)
    set s (string replace -ra '[œŒ]' oe -- $s)

    string lower -- $s | string replace -ra '[^a-z0-9./-]+' '_' | string replace -ra '^[-_./]+|[-_./]+$' ''
end
