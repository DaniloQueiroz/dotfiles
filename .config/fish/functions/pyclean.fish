function pyclean --description 'Clean pyc files' 
    command pyclean -v .; and find . -name *.pyc -delete
    return 0
end

