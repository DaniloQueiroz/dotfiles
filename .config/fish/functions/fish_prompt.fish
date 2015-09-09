function fish_prompt --description 'Write out the prompt'
  set -l last_status $status

  # Virtualenv
  if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (python --version 2>&1)@(basename "$VIRTUAL_ENV") ")" (set_color normal) " "
  end

  # RVM
  if set -q rvm_version
    if test -n (rvm-prompt g)
        echo -n -s (set_color -b blue white) "(" (rvm-prompt) ")" (set_color normal) " "
    end
  end

  # User
  set_color $fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n '@'

  # Host
  set_color $fish_color_host
  echo -n (hostname -s)
  set_color normal

  echo -n ':'

  # PWD
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal

  # GIT
  __terlar_git_prompt

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  # Prompt
  echo -n ' ➤ '
  set_color normal
end
