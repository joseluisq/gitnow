# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_get_clip_program -d "Gets the current clip installed program"
    set -l v_paste

    if type -q xclip
        set v_paste "xclip -selection clipboard -o"
    else if type -q wl-clipboard
        set v_paste "wl-paste"
    else if type -q xsel
        set v_paste "xsel --clipboard --output"
    else if type -q pbpaste
        set v_paste "pbpaste"
    end

    echo -n $v_paste
end
