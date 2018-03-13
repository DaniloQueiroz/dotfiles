function on_pwd_changed --on-variable PWD
  # skip if its a command substitution
  status --is-command-substitution; and return

  # remove previous folder from PATH
  set -e PATH[1]

  # Check .files
  if test -f '.venv'  # virtualenv loading
    set _venv (cat .venv)
    echo "loading virtualenv $_venv..."
    pyenv activate $_venv
  end

  # add current dir to PATH
  if test $PATH[1] != $PWD
    set -x PATH $PWD $PATH
  end
end
