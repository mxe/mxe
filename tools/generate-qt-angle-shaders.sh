#! /bin/bash

set -euo pipefail

if [ "${FXC:-}" = "" ] || ! [ -f "$FXC" ]; then
  echo "Specify path to fxc.exe in FXC variable. It is part of the directx SDK."
  exit 1
fi

QT_SOURCE_PATH=$(echo ./gits/qtbase*)

if ! [ -d "$QT_SOURCE_PATH" ]; then
  echo "Can't find Qt source path. Run: make init-git-qtbase"
  exit 1
fi

get_fxc_arguments() {
  DXSDK_DIR=D qmake -o - | sed -n -e 's/^\s*"D.*fxc.exe"//p'
}

echo "Running fxc to generate the shaders"
cd "${QT_SOURCE_PATH}/src/angle/src/QtANGLE"

get_fxc_arguments | while read command; do
  wine "$FXC" $command
done
