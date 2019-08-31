# load files from conf.d dir
if status is-interactive 
and not set -q TMUX
    tmux has-session -t bz
    if test $status -eq 0
        exec tmux attach-session -t bz
    else
        exec tmux new -s bz
    end

    for conf in ~/.config/fish/conf.d/*.fish
        source $conf
    end 

    set -e fish_greeting

    # configure less colors / colored man pages
    set -xg LESS_TERMCAP_mb (printf "\e[01;31m")      # begin blinking
    set -xg LESS_TERMCAP_md (printf "\e[01;31m")      # begin bold
    set -xg LESS_TERMCAP_me (printf "\e[0m")          # end mode
    set -xg LESS_TERMCAP_se (printf "\e[0m")          # end standout-mode
    set -xg LESS_TERMCAP_so (printf "\e[01;44;33m")   # begin standout-mode - info box
    set -xg LESS_TERMCAP_ue (printf "\e[0m")          # end underline
    set -xg LESS_TERMCAP_us (printf "\e[01;32m")      # begin underline

    # load on_pwd_changed handle
    on_pwd_changed
end
