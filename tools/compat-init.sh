#!/bin/sh

# Ported from main Makefile
MAKE='make'
SED='sed'
SORT='sort'

if [ gmake --help >/dev/null 2>&1 ]; then
    MAKE='gmake'
fi
if [ gsed --help >/dev/null 2>&1 ]; then
    SED='gsed'
fi
if [ gsort --help >/dev/null 2>&1 ]; then
    SORT='gsort'
fi

WGET="wget --user-agent=$(wget --version |
         $SED -n 's,GNU \(Wget\) \([0-9.]*\).*,\1/\2,p')"
