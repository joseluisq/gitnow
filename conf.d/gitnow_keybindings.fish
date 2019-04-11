# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow
# 
# NOTE:
#   Fish 2.2.0 doesn't include native snippet support.
#   Upgrade to Fish >= 2.3.0 or append the following code to your ~/.config/fish/config.fish

# Alt + S
bind \es "echo; if state; commandline -f repaint; else ; end"

# Alt + E
bind \ee "echo; if stage; commandline -f repaint; else ; end"

# Ctrl + E
bind \ce "echo; if unstage; commandline -f repaint; else ; end"

# Alt + C
bind \ec "echo; if commit-all; commandline -f repaint; else ; end"

# Alt + D
bind \ed "echo; if pull; commandline -f repaint; else ; end"

# Alt + P
bind \ep "echo; if push; commandline -f repaint; else ; end"

# Alt + U
bind \eu "echo; if upstream; commandline -f repaint; else ; end"

# Alt + L
bind \el "echo; if logs; commandline -f repaint; else ; end"

# `feature` & `hotfix` depend on some clipboard program

set -l xpaste

if type -q xclip
    set xpaste "xclip -selection clipboard"
else
    if type -q xsel
        set xpaste "xsel --clipboard --output"
    end

    if type -q pbpaste
        set xpaste "pbpaste"
    end
end

if test -n $xpaste
    # Alt + F
    bind \ef "echo; if feature (\"xpaste\"); commandline -f repaint; else ; end"

    # Alt + H
    bind \eh "echo; if hotfix (\"xpaste\"); commandline -f repaint; else ; end"
end
