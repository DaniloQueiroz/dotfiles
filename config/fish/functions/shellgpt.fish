function shellgpt -d "Ask gpt to execute shell operations"
  set -l cmd (commandline -b)
  commandline -f kill-whole-line
  echo -en "\ngpt > "
  sgpt --shell "$cmd"
  commandline -f repaint
end
