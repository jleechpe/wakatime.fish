###
# wakatime.fish
#
#　hook script to send wakatime a tick (unofficial)
# see: https://github.com/ik11235/wakatime.fish
###

function __register_wakatime_fish_post_exec -e fish_postexec
    if set -q FISH_WAKATIME_DISABLED
        return 0
    end

    set -l PLUGIN_NAME "jleechpe/wakatime.fish"
    set -l PLUGIN_VERSION "0.0.4"

    set -l project
    set -l wakatime_path

    if type -p wakatime 2>&1 >/dev/null
        set wakatime_path (type -p wakatime)
    else if type -p ~/.wakatime/wakatime-cli 2>&1 >/dev/null
        set wakatime_path (type -p ~/.wakatime/wakatime-cli)
    else
        echo "wakatime command not found. Please read \"https://wakatime.com/terminal\" and install wakatime."
        return 1
    end

    if git rev-parse --is-inside-work-tree &>/dev/null
        set project (basename (git rev-parse --show-toplevel))
    else
        set project Terminal
    end

    if not test $argv = exit
        $wakatime_path --write --plugin "$PLUGIN_NAME/$PLUGIN_VERSION" --entity-type app --alternate-project "$project" --alternate-language fish --category debugging --entity $argv &>/dev/null &
    end
end
