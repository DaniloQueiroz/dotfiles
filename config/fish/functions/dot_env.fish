function dot_env --description "Load .env file"
  for line in (cat .env | grep -v '^#')
    set kv (string split -m 1 '=' $line)
    set -gx $kv[1] $kv[2]
    echo "exported key $kv[1]"
  end
end