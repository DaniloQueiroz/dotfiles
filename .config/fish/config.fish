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
