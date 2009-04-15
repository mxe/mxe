# SQLite

PKG             := sqlite
$(PKG)_VERSION  := 3.6.13
$(PKG)_CHECKSUM := 78395c994d7c920e83a419c69af7e4ce2f2b1ba0
$(PKG)_SUBDIR   := sqlite-$($(PKG)_VERSION)
$(PKG)_FILE     := sqlite-amalgamation-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.sqlite.org/
$(PKG)_URL      := http://www.sqlite.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.sqlite.org/download.html' | \
    grep 'sqlite-amalgamation-' | \
    $(SED) -n 's,.*sqlite-amalgamation-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-readline \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
