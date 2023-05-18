function chatgpt -d "Ask questions to chatgpt"

  function ask_question
    read -P "?> " prompt
    if test -n "$prompt"
      answer_question "$prompt"
    end
  end

  function answer_question -a prompt
    echo -n "chatgpt> "
    sgpt --chat $TERMINALSESSION "$prompt"
    ask_question
  end

  tput smcup
  tput cup 0 0
  ask_question
  tput rmcup
end