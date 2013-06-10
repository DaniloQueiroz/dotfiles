function myfunc --on-event virtualenv_did_activate
    if test -f $VIRTUAL_ENV/bin/postactivate.fish
        . $VIRTUAL_ENV/bin/postactivate.fish
    end
    alias deactivate 'vf deactivate; and functions -e deactivate'
end
