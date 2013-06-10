function s --description 'Manage multiple screen profiles for byobu'
    if test -z $argv
        set argv personal
    end

    switch $argv
        case help
            echo "Use 'screen list' to list sessions;"
            echo "or 'screen  <window_name>' to start/connect to a given session"
        case list
            byobu -ls;
        case '*'
            set SCREEN_PROFILE $argv
            set SCREEN_SESSION (screen -ls | grep $SCREEN_PROFILE | awk '{ print $1 }')
            
            if not test -z $SCREEN_SESSION
                screen -AOxRR $SCREEN_SESSION
            else
                set -x BYOBU_WINDOWS $SCREEN_PROFILE
                byobu -S $BYOBU_WINDOWS
            end
            set -e SCREEN_PROFILE
            set -e SCREEN_SESSION
            set -e BYOBU_WINDOWS
    end
end
