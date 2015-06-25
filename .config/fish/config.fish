# load files from conf.d dir
set -U fish_color_status red
set -U fish_color_cwd_root red
set -U fish_color_cwd green
set -U fish_color_status red
set -U fish_color_user -o green
set -U fish_color_host -o cyan

for conf in ~/.config/fish/conf.d/*.fish
    . $conf
end

set -e fish_greeting

# configure less colors / colored man pages
set -xU LESS_TERMCAP_mb (printf "\e[01;31m")      # begin blinking
set -xU LESS_TERMCAP_md (printf "\e[01;31m")      # begin bold
set -xU LESS_TERMCAP_me (printf "\e[0m")          # end mode
set -xU LESS_TERMCAP_se (printf "\e[0m")          # end standout-mode
set -xU LESS_TERMCAP_so (printf "\e[01;44;33m")   # begin standout-mode - info box
set -xU LESS_TERMCAP_ue (printf "\e[0m")          # end underline
set -xU LESS_TERMCAP_us (printf "\e[01;32m")      # begin underline

# load on_pwd_changed handle
on_pwd_changed
