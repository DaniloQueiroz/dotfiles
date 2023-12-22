function cheatsheet -d "Prints a cheatsheet with abbreviations, aliases and keybinds"   
  set_color --bold blue  
  printf " > Abbreviations\n"
  set_color normal
  abbr | grep -v 'regex' | awk '{ print " • " $(NF-1) " → " $NF }'
  
  set_color --bold blue  
  printf "\n > Aliases\n"
  set_color normal
  alias | awk '{out=$3; for(i=4;i<=NF;i++){out=out" "$i} print " • " $2 " → " out}'

  set_color --bold blue  
  printf "\n > Keybindings\n"
  set_color normal
  bind | grep -v "preset" | awk '{ print " • " $(NF-1) " → " $NF }' | sed -e 's/\\\c/ctrl+/' | sed -e 's/\\\e/alt+/'

  set_color --bold blue
  printf "\n >> asdf\n"
  set_color normal
  asdf current 1&| grep -v "No version is set." | awk '{ print " • " $(NF-1) " → " $NF }'
end
  