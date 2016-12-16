# This file is part of MXE.
# See index.html for further information.

PKG             := tlspool-gui
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := e8ba8c040b9a5520d80e58c6a4cc13c1e1fc15f03ecd51b5a41c5038e591f40b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/amarsman/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := qtsvg tlspool

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && $(TARGET)-cmake ..

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install DESTDIR='$(PREFIX)/$(TARGET)'
endef

