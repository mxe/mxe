#!/bin/bash

which dirname >/dev/null || exit 1
which pidof >/dev/null || exit 1
script="$(dirname "$0")/update.sh"
pidof -x "${script}" >/dev/null 2>&1 && exit 0
"${script}"
exit $?
