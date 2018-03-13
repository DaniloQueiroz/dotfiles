# EDITOR
set -xg EDITOR vim
# PAGER
set -xg PAGER '/usr/bin/less -MQRSi'
# PYTHON no '.pyc' files
set -xg PYTHONDONTWRITEBYTECODE 'please_dont'
# Set VIRTUALFISH_HOME
set -xg VIRTUALFISH_HOME $HOME/.virtualenvs
set -eu PIP_CERT
