function dot_source --description "Load .source file"
  ## source activation
  set _src (cat .source)
  echo "loading $_src..."
  source $_src
end
