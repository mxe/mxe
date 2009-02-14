# IlmBase
# http://www.openexr.com/

PKG            := ilmbase
$(PKG)_VERSION := 1.0.1
$(PKG)_SUBDIR  := ilmbase-$($(PKG)_VERSION)
$(PKG)_FILE    := ilmbase-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openexr.com/downloads.html' | \
    grep 'ilmbase-' | \
    $(SED) -n 's,.*ilmbase-\([1-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threading=no \
        --disable-posix-sem
    # do the first build step by hand, because programs are built that
    # generate source files
    cd '$(1)/Half' && g++ eLut.cpp -o eLut
    '$(1)/Half/eLut' > '$(1)/eLut.h'
    cd '$(1)/Half' && g++ toFloat.cpp -o toFloat
    '$(1)/Half/toFloat' > '$(1)/toFloat.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
