function chatgpt -d "Ask questions to chatgpt" -a chatsession
  clear
  if test -z "$chatsession"
      set -f chatsession $TERMINALSESSION
  end
  sgpt --shell --repl $chatsession 
  fish_prompt
end
