function eclipse --description 'finds and launch eclipse'
    eval (find ~ -name eclipse.ini -exec dirname '{}' + -quit)/eclipse $argv
end
