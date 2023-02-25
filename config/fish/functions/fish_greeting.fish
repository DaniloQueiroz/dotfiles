function fish_greeting -d "what's up, fish?"
  if test -r /etc/motd
    set_color $nord3
    cat /etc/motd
  end

  set_color normal; and echo -n ":: "
  set_color $nord8; and uname -npsr
  set_color normal; and echo -n ":: "
  set_color $nord7; and uptime -p
  set_color normal; and echo ""
end