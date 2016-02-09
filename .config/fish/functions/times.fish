function times --description "Show current time on Europe/Berlin"
    set TZs 'Europe/Berlin' 'America/Sao_Paulo' 'Europe/Minsk'
    for tz in $TZs
        set -x TZ $tz 
        echo -n "Current Time on $tz: "
        date
    end
end
