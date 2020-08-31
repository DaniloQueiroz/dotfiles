function fish_prompt --description 'Write out the prompt'
  set -g fish_color_status red
  set -g fish_color_cwd_root red
  set -g fish_color_cwd magenta
  set -g fish_color_status red
  set -g fish_color_user -o blue
  set -g fish_color_host -o cyan
  set -l last_status $status

  # PyEnv
  if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (python --version 2>&1)@(basename "$VIRTUAL_ENV") ")" (set_color normal) " "
  end

  # User
  set_color $fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n '@'

  # Host
  set_color $fish_color_host
  echo -n (hostnamectl --static)
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
  echo -n ' ❯ '
  set_color normal
end
