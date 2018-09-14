function on_pwd_changed --on-variable PWD
  # skip if its a command substitution
  status --is-command-substitution; and return

  ## venv auto activation
  # check .venv files
  if test -f '.venv'  # virtualenv loading
    set _venv (cat .venv)
    echo "loading virtualenv $_venv..."
    venv activate $_venv
  end

  if test -f '.source'
    set _src (cat .source)
    echo "loading $_src..."
    source $_src
  end
end
