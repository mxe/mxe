# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdvdetect
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.71.0
$(PKG)_CHECKSUM := b098e04660532df78836f50bc0a8044b66c6659b07a6bff6609724ad30a87192
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/nschlia/libdvdetect/releases/download/RELEASE_0_71/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc tinyxml

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/nschlia/libdvdetect/tags/' | \
    grep '<a href="/nschlia/libdvdetect/archive/' | \
    $(SED) -n 's,.*href="/nschlia/libdvdetect/archive/RELEASE_\([0-9][^"]*\)\.tar.*,\1,p' | \
    sort | uniq | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
              '$(SOURCE_DIR)'/configure \
              $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/include' -j '$(JOBS)' install
    $(MAKE) -C '$(BUILD_DIR)/lib' -j '$(JOBS)' install
    
    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: fast database lookup for DVDs'; \
     echo 'Libs: -L$${libdir} -ldvdetect'; \
     echo 'Cflags: -I$${includedir}';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # copy a test binary
    cp '$(BUILD_DIR)/examples/c/dvdinfo.exe' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef