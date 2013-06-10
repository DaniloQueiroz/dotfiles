function workon --description 'Activate a virtualenv'
    vf activate $argv
    alias deactivate 'vf deactivate; and functions -e deactivate'
end
