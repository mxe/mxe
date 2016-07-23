# This file is part of MXE.
# See index.html for further information.

# enable native build of luajit for wrk
# leave build rule in src/luajit.mk for other uses (i.e. build-pkg)

luajit_TARGETS  := $(BUILD) $(MXE_TARGETS)
