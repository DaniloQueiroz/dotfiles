# Colorscheme: Nord
set nord0 2e3440
set nord1 3b4252
set nord2 434c5e
set nord3 4c566a
set nord4 d8dee9
set nord5 e5e9f0
set nord6 eceff4
set nord7 8fbcbb
set nord8 88c0d0
set nord9 81a1c1
set nord10 5e81ac
set nord11 bf616a
set nord12 d08770
set nord13 ebcb8b
set nord14 a3be8c
set nord15 b48ead

# fish colors config
set -U fish_color_normal $nord4
set -U fish_color_command $nord9
set -U fish_color_quote $nord14
set -U fish_color_redirection $nord9
set -U fish_color_end $nord8
set -U fish_color_error $nord11
set -U fish_color_param $nord6
set -U fish_color_comment $nord2
set -U fish_color_match $nord8
set -U fish_color_selection $nord4 --bold --background=$nord3
set -U fish_color_search_match $nord8 --background=$nord3
set -U fish_color_history_current --bold
set -U fish_color_operator $nord9
set -U fish_color_escape $nord13
set -U fish_color_cwd $nord8
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion $nord3
set -U fish_color_user $nord8
set -U fish_color_host $nord7
set -U fish_color_cancel $nord15
set -U fish_pager_color_prefix $nord13
set -U fish_pager_color_progress $nord12
set -U fish_pager_color_completion $nord6
set -U fish_pager_color_description $nord10
set -U fish_pager_color_selected_background --background=$nord3
set -U fish_color_host_remote $nord12

# git prompt colors config
set __fish_git_prompt_color_branch $nord15
set __fish_git_prompt_color_branch_dirty $nord13
set __fish_git_prompt_color_branch_detached $nord12
set __fish_git_prompt_color_branch_staged $nord14

# ??
#set -U fish_color_option
#set -U fish_pager_color_selected_completion
#set -U fish_pager_color_secondary_completion
#set -U fish_pager_color_secondary_prefix
#set -U fish_pager_color_selected_prefix
#set -U fish_pager_color_background
#set -U fish_pager_color_selected_description
#set -U fish_color_keyword
#set -U fish_pager_color_secondary_background
#set -U fish_pager_color_secondary_description
