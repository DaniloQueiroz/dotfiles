# EDITOR
set -xg EDITOR vim
# PAGER
set -xg PAGER '/usr/bin/less -MQRSi'
# PYTHON no '.pyc' files
set -xg PYTHONDONTWRITEBYTECODE 'please_dont'

# to make gpg work with yubico
set -xg GPG_TTY $tty
