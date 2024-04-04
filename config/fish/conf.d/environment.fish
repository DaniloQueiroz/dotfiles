# EDITOR
set -xg EDITOR vim
# PAGER
set -xg PAGER '/usr/bin/less -MQRSi'
# PYTHON no '.pyc' files
set -xg PYTHONDONTWRITEBYTECODE 'please_dont'

# OpenAI
if test -r ~/.local/share/fish/openai.key
  set -x OPENAI_API_KEY (cat ~/.local/share/fish/openai.key)
end
