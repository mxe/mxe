# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mxml
$(PKG)_WEBSITE  := https://michaelrsweet.github.io/mxml/
$(PKG)_DESCR    := Mini-XML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.11
$(PKG)_CHECKSUM := 7d3dfe661e50908fe41aef9b97ba6f7f158cab5208515c6be9f5bc9daf032329
$(PKG)_GH_CONF  := michaelrsweet/mxml/tags, v
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD
    # doesn't support out-of-source builds
    # https://github.com/michaelrsweet/mxml/issues/135
    cd '$(SOURCE_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-shared \
        --enable-static \
        --enable-threads
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' libmxml.a
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/mxml.h'  '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/mxml.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    # shared libs are easier to do ourselves in the case where all
    # functions are exported.
    # https://github.com/michaelrsweet/mxml/issues/188
    # https://github.com/michaelrsweet/mxml/issues/192
    $(if $(BUILD_STATIC),\
        $(MAKE) -C '$(SOURCE_DIR)' -j 1 install-libmxml.a \
    $(else), \
        $(MAKE_SHARED_FROM_STATIC) '$(SOURCE_DIR)/libmxml.a' -lpthread)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-mxml.exe' \
        `'$(TARGET)-pkg-config' mxml --cflags --libs`
endef
