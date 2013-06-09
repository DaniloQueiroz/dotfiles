# load files from conf.d dir
for conf in ~/.config/fish/conf.d/*.fish
    . $conf
end

if status --is-interactive; and test (wc -l /var/spool/mail/danilo | awk '{ print $1 }') != 1
    set fish_greeting "You have new mail!"
end
