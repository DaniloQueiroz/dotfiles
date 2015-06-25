function s --description 'Manage multiple screen profiles for byobu'
  if test -z $argv
      set argv personal
  end

  switch $argv
    case help
      echo "Use 's list' to list sessions;"
      echo "or 's  <window_name>' to start/connect to a given session"
    case list
      screen -ls;
    case '*'
      set -x SCREEN_PROFILE $argv
      set SCREEN_SESSION (screen -ls | grep $SCREEN_PROFILE | awk '{ print $1 }')

      if not test -z $SCREEN_SESSION
          screen -AOxRR $SCREEN_SESSION
      else
          screen -c $HOME/.screen/screenrc -t '' -S $SCREEN_PROFILE
      end
      set -e SCREEN_PROFILE
      set -e SCREEN_SESSION
      set -e BYOBU_WINDOWS
  end
end
