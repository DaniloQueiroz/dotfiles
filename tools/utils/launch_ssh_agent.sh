#!/usr/bin/fish

pgrep -a ssh-agent
if test $status -eq 1
    echo "starting ssh-agent"
    set -eu SSH_AUTH_SOCK
    set -Ux SSH_AUTH_SOCK (ssh-agent | grep SSH_AUTH_SOCK| awk -F'[=;]' '{ print $2 }')
    ssh-add /home/danilo/.ssh/id_rsa
    pgrep -a ssh-agent
    ssh-add -L
    echo $SSH_AUTH_SOCK
else
    echo "ssh-agent already running"
end
