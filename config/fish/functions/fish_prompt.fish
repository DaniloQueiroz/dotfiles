# Git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_dirtystate red
set __fish_git_prompt_color_stagedstate green
set __fish_git_prompt_color_upstream cyan

# Git Status
set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '⇢'
set __fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_char_upstream_equal ''
set __fish_git_prompt_char_upstream_ahead '⇡'
set __fish_git_prompt_char_upstream_behind '⇣'
set __fish_git_prompt_char_upstream_diverged '⇡⇣'

# Colors
set __fish_color_status red
set __fish_color_cwd_root red
set __fish_color_cwd magenta
set __fish_color_status red
set __fish_color_user -o blue
set __fish_color_host -o cyan


function fish_prompt --description 'Write out the prompt'
  set -l last_status $status

  # TERMINALSESSION - show current terminalsession name
  if set -q TERMINALSESSION
    echo -n -s (set_color red)"$TERMINALSESSION"(set_color normal)·
  end

  # Python VirtualEnv
  if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (python --version 2>&1)@(basename "$VIRTUAL_ENV") ")" (set_color normal) " "
  end

  # User
  set_color $__fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n '@'

  # Host
  set_color $__fish_color_host
  echo -n (hostnamectl --static)
  set_color normal

  echo -n ':'

  # PWD
  set_color $__fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal

  # GIT
  __terlar_git_prompt

  if not test $last_status -eq 0
    set_color $__fish_color_error
  end

  # Prompt
  echo -n ' ❯ '
  set_color normal
end
