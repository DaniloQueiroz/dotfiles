function on_exit --on-process %self --description finalize hooks
    # stop gradle daemon
    if ps ux | grep gradle > /dev/null
        gradle --stop
    end
end
