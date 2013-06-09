# mail box configuration
set -U MAIL /var/spool/mail/(whoami)
set -U MAILCHECK 30
# EDITOR
set -U EDITOR vim
# PYTHON no '.pyc' files
set -U PYTHONDONTWRITEBYTECODE 'please_dont'

