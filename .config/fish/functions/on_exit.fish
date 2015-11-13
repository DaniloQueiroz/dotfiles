function on_exit --on-process %self 
    # stop gradle daemon
    gradle --stop
end
