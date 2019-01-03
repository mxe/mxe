# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := neon
$(PKG)_WEBSITE  := https://web.archive.org/web/webdav.org/neon/
$(PKG)_DESCR    := HTTP and WebDAV client library (libneon)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.30.2
$(PKG)_CHECKSUM := db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://fossies.org/linux/www/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL_2    := https://mirrorservice.org/sites/distfiles.macports.org/$(PKG)/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc expat gettext openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://mirrorservice.org/sites/distfiles.macports.org/$(PKG)/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
        ne_cv_fmt_size_t=%lu \
        ne_cv_fmt_ssize_t=%lu \
        ne_cv_fmt_off64_t=%I64u \
        ne_cv_fmt_time_t=%lu \
        ne_cv_libsfor_socket=-lws2_32 \
        ne_cv_libsfor_gethostbyname=-lws2_32 \
        ne_cv_os_uname= \
        '$(SOURCE_DIR)'/configure \
              $(MXE_CONFIGURE_OPTS) \
              $(MXE_DISABLE_DOCS) \
              PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
              --with-ssl=yes
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install-lib install-headers install-nls

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: neon is an HTTP and WebDAV client library'; \
     echo 'Requires.private: openssl'; \
     echo 'Libs: -L$${libdir} -lneon'; \
     echo 'Libs.private: -L$${libdir} -lintl -liconv'; \
     echo 'Cflags: -I$${includedir}'; \
    ) \
    > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # create test binary
    $(TARGET)-gcc \
        -W -Wall -Werror -std=c11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config neon --cflags --libs`
endef
