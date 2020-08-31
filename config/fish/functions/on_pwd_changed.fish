function on_pwd_changed --on-variable PWD
  # skip if its a command substitution
  status --is-command-substitution; and return

  ## source activation
  if test -f '.source'
    set _src (cat .source)
    echo "loading $_src..."
    source $_src
  end
end
