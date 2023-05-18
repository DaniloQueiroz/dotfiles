if test -r ~/.local/share/fish/openai.key
  set -x OPENAI_API_KEY (cat ~/.local/share/fish/openai.key)

  bind --user \e\r shellgpt
  bind --user \eg chatgpt
end
