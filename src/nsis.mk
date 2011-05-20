# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# NSIS
PKG             := nsis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.46
$(PKG)_CHECKSUM := 2cc9bff130031a0b1d76b01ec0a9136cdf5992ce
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_WEBSITE  := http://nsis.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/nsis/NSIS 2/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://nsis.svn.sourceforge.net/viewvc/nsis/NSIS/tags/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="v\([0-9]\)\([^"]*\)".*,\1.\2,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && scons \
        MINGW_CROSS_PREFIX='$(TARGET)-' \
        PREFIX='$(PREFIX)/$(TARGET)' \
        `[ -d /usr/local/include ] && echo APPEND_CPPPATH=/usr/local/include` \
        `[ -d /usr/local/lib ]     && echo APPEND_LIBPATH=/usr/local/lib` \
        SKIPUTILS='NSIS Menu' \
        install
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/makensis' '$(PREFIX)/bin/$(TARGET)-makensis'
endef
