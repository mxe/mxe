# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hunspell
$(PKG)_WEBSITE  := https://hunspell.github.io/
$(PKG)_DESCR    := Hunspell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.2
$(PKG)_CHECKSUM := 69fa312d3586c988789266eaf7ffc9861d9f6396c31fc930a014d551b59bbd6e
$(PKG)_GH_CONF  := hunspell/hunspell/tags, v
$(PKG)_DEPS     := cc gettext libiconv pthreads readline

define $(PKG)_BUILD
    # Note: the configure file doesn't pick up pdcurses, so "ui" is disabled
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-warnings \
        --without-ui \
        --with-readline
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # Test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
        $(if $(BUILD_STATIC), -DHUNSPELL_STATIC) \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-hunspell.exe' \
        `'$(TARGET)-pkg-config' hunspell --cflags --libs`
endef
