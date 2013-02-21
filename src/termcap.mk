# This file is part of MXE.
# See index.html for further information.

PKG             := termcap
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 42dd1e6beee04f336c884f96314f0c96cc2578be
$(PKG)_SUBDIR   := termcap-$($(PKG)_VERSION)
$(PKG)_FILE     := termcap-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/termcap/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
#    wget -q -O- 'https://gnuwin32.sourceforge.org/packages/termcap.htm' | \
#    $(SED) -n 's_.*>Version</h.*_\1_ip' | \
#    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' &&  ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static 

    $(MAKE) -C '$(1)' 
    $(MAKE) -C '$(1)' install 

endef

