function on_pwd_changed --on-variable PWD
  # skip if its a command substitution
  status --is-command-substitution; and return

  ## venv Auto activation
  # Check .venv files
  if test -f '.venv'  # virtualenv loading
    set _venv (cat .venv)
    echo "loading virtualenv $_venv..."
    venv activate $_venv
  end
end
