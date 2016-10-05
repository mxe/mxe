# This file is part of MXE. See LICENSE.md for licensing information.

# enable native build for luarocks
# leave build rule in src/lua.mk for other uses (i.e. build-pkg)

lua_TARGETS  := $(BUILD) $(MXE_TARGETS)
