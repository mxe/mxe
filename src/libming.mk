# This file is part of MXE.
# See index.html for further information.

PKG             := libming
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e803b3b94a00a361e3415105f26112cf6f7bac81
$(PKG)_SUBDIR   := ming-$($(PKG)_VERSION)
$(PKG)_FILE     := ming-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/projects/$(PKG)/Releases/($(PKG)_FILE)
$(PKG)_URL_2	:= http://sourceforge.net/projects/ming/files/Releases/ming-0.4.4.tar.bz2/download
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libming.org/Releases' | \
    $(SED) -n 's_.ming-\([0-9]\.[0-9]\.[0-9]\).*tar.bz2_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && sh autogen.sh
 
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(1)' -j '$(JOBS)'

    $(MAKE) -C '$(1)' install 

endef
