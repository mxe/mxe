# This file is part of MXE. See LICENSE.md for licensing information.

# void uses libressl which isn't compatible with cmake's internal curl
# see: https://github.com/mxe/mxe/issues/2156

_cmake_CONFIGURE_OPTS = --system-curl
