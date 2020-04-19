#!/bin/bash

SESSIOND_PID=$(cat ${XDG_RUNTIME_DIR}/dude-session.pid)
kill ${SESSIOND_PID}
i3-msg exit
