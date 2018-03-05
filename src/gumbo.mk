# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gumbo
$(PKG)_WEBSITE  := https://github.com/google/gumbo-parser
$(PKG)_DESCR    := Gumbo, an HTML5 parsing library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.1
$(PKG)_CHECKSUM := 28463053d44a5dfbc4b77bcf49c8cee119338ffa636cc17fc3378421d714efad
$(PKG)_GH_CONF  := google/gumbo-parser/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd $(SOURCE_DIR) && ./autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS=

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
