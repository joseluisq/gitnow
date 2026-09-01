# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_get_clip_program -d "Gets the current clip installed program"
    set -l v_paste

    if command -q xclip
        set v_paste "xclip -selection clipboard -o"
    else if command -q wl-paste
        set v_paste "wl-paste"
    else if command -q xsel
        set v_paste "xsel --clipboard --output"
    else if command -q pbpaste
        set v_paste "pbpaste"
    end

    echo -n $v_paste
end
