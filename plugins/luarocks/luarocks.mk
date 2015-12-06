# This file is part of MXE.
# See index.html for further information.

PKG             := luarocks
$(PKG)_WEBSITE  := https://luarocks.org/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := 4f0427706873f30d898aeb1dfb6001b8a3478e46a5249d015c061fe675a1f022
$(PKG)_SUBDIR   := luarocks-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://keplerproject.github.io/luarocks/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lua

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://keplerproject.github.io/luarocks/releases/' | \
    $(SED) -n 's,.*luarocks-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -h | tail -1
endef

# shared-only because Lua loads modules in runtime

define $(PKG)_BUILD_SHARED
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --rocks-tree='$(PREFIX)/$(TARGET)' \
        --lua-version='$(lua_SHORTVER)' \
        --with-lua='$(PREFIX)/$(TARGET)' \
        --with-lua-bin='$(PREFIX)/$(BUILD)/bin' \
        --with-downloader='wget' \
        --with-md5-checker='openssl'
    $(MAKE) -C '$(1)' build \
        LUAROCKS_UNAME_S="MXE" \
        LUAROCKS_UNAME_M="$(TARGET)"
    $(MAKE) -C '$(1)' install

    # move installed lua file luarocks to luarocks.lua
    mv '$(PREFIX)/$(TARGET)/bin/luarocks' '$(PREFIX)/$(TARGET)/bin/luarocks.lua'

    # create bash wrapper adding inter-process mutex
    # see https://github.com/mxe/mxe/pull/1017#issuecomment-161557440
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/luarocks'
    (echo '#!/usr/bin/env bash'; \
     echo 'echo "== Using MXE wrapper: $(PREFIX)/$(TARGET)/bin/luarocks"'; \
     echo '# Creating a directory is an atomic operation, that is why'; \
     echo '# it can be used as a mutex.'; \
     echo '# See http://wiki.bash-hackers.org/howto/mutex'; \
     echo 'while ( ! mkdir "$(PREFIX)/$(TARGET)/lib/luarocks/lock.dir" ); do'; \
     echo '    echo "Waiting for $(PREFIX)/$(TARGET)/lib/luarocks/lock.dir to lock"'; \
     echo '    sleep 5'; \
     echo 'done'; \
     echo '"$(PREFIX)/$(TARGET)/bin/luarocks.lua" "$$@"'; \
     echo 'rmdir "$(PREFIX)/$(TARGET)/lib/luarocks/lock.dir"'; \
    ) \
             > '$(PREFIX)/$(TARGET)/bin/luarocks'
    chmod 0755 '$(PREFIX)/$(TARGET)/bin/luarocks'
    # remove lock dir if it exists after previous failed installation
    -rmdir "$(PREFIX)/$(TARGET)/lib/luarocks/lock.dir"

    # symlink
    ln -sf '$(PREFIX)/$(TARGET)/bin/luarocks' '$(PREFIX)/bin/$(TARGET)-luarocks'

    # create wine wrapper for testing
    echo 'LUA_PATH="$(PREFIX)/$(TARGET)/share/lua/$(lua_SHORTVER)/?.lua;$(PREFIX)/$(TARGET)/share/lua/$(lua_SHORTVER)/?/init.lua;$$LUA_PATH"' > '$(PREFIX)/bin/$(TARGET)-lua'
    echo 'LUA_CPATH="$(PREFIX)/$(TARGET)/lib/lua/$(lua_SHORTVER)/?.dll;;$$LUA_CPATH"' >> '$(PREFIX)/bin/$(TARGET)-lua'
    echo 'export LUA_PATH LUA_CPATH' >> '$(PREFIX)/bin/$(TARGET)-lua'
    echo 'exec wine $(PREFIX)/$(TARGET)/bin/lua.exe "$$@"' >> '$(PREFIX)/bin/$(TARGET)-lua'
    chmod +x '$(PREFIX)/bin/$(TARGET)-lua'
endef
