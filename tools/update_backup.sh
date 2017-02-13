#!/bin/bash

# Cron script updating https://gitlab.com/starius/mxe-backup2
# This script is a wrapper for tools/update_backup.py

set -xue

BACKUP="/home/mxe-backup/mxe-backup2"
MXE="/home/mxe-backup/mxe"

cd "$BACKUP" && git clean -fdx
if cd "$MXE" && git pull | grep --silent 'Already up-to-date.'; then
    echo "No new commits"
    exit 0
fi
cd "$MXE" && make download
cd "$MXE" && ./tools/update_backup.py --backup-dir "$BACKUP"
if ! ( cd "$BACKUP" && git status --porcelain | grep --silent '^??' ); then
    echo "Nothing was added"
    exit 0
fi
cd "$BACKUP" && git add .
cd "$BACKUP" && git commit -m 'update backup'
cd "$BACKUP" && git push
