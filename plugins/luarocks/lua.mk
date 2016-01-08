# This file is part of MXE.
# See index.html for further information.

# enable native build for luarocks
# leave build rule in src/lua.mk for other uses (i.e. build-pkg)

lua_TARGETS  := $(BUILD) $(MXE_TARGETS)
