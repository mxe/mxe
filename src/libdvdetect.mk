# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdvdetect
$(PKG)_WEBSITE  := https://www.dvdetect.de/
$(PKG)_DESCR    := Fast database lookup for DVDs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.71
$(PKG)_CHECKSUM := 55de9fffb3c14459148b5de6c16cded6aa8aff62df69150bfb4b1a1815a7d1ef
$(PKG)_GH_CONF  := nschlia/libdvdetect/tags,RELEASE_,,,_
$(PKG)_DEPS     := cc openssl tinyxml

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
     echo 'Requires.private: openssl'; \
     echo 'Libs: -L$${libdir} -ldvdetect -lws2_32'; \
     echo 'Libs.private: -L$${libdir} -ltinyxml -lstdc++'; \
     echo 'Cflags: -I$${includedir}'; \
    ) \
    > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # create test binary
    $(TARGET)-gcc \
        -W -Wall -Werror \
        '$(SOURCE_DIR)/examples/c/dvdinfo.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config libdvdetect --cflags --libs`
endef
