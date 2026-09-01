# GitNow — Speed up your Git workflow. 🐠
# https://github.com/joseluisq/gitnow

function __gitnow_get_latest_semver_release_tag
    for tg in (__gitnow_get_tags_ordered)
        if string match -qr '^v?\d+\.\d+\.\d+$' -- $tg
            echo $tg
            break
        end
    end
end
