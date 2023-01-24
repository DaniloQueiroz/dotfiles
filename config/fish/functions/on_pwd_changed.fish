function on_pwd_changed --on-variable PWD
  # skip if its a command substitution
  status --is-command-substitution; and return

  if test -f '.source'
    echo -n "'.source' file found... "
    dot_source
  end

  if test -f '.env'
    echo -n "'.env' file found... "
    dot_env
  end
end
