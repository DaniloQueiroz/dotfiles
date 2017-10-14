function venv --description 'Python virtual envs using pyenv'
  if test -z "$argv"
    echo "Wrong usage. Params: [ls|rm|new|activate|deactivate]"
    exit 1
  end

  switch $argv[1]
    case deactivate
      pyenv deactivate
    case activate
      pyenv activate $argv[2]
    case ls
      pyenv virtualenvs
    case rm
      if test -n "$VIRTUAL_ENV"
        set RM_ENV "$VIRTUAL_ENV"
        pyenv deactivate
        pyenv uninstall (basename "$RM_ENV"); and rm "$RM_ENV"
      else
        echo "activate the venv you want to remove"
      end
    case new
      pyenv virtualenv $argv[2] $argv[3]
      pyenv activate $argv[3]
    case connect
      echo (basename "$VIRTUAL_ENV") > .venv
  end
end
