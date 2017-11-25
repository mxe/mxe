# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tidy-html5
$(PKG)_WEBSITE  := http://www.html-tidy.org/
$(PKG)_DESCR    := HTML/XML syntax checker and reformatter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.0
$(PKG)_CHECKSUM := a2d754b7349982e33f12d798780316c047a3b264240dc6bbd4641542e57a0b7a
$(PKG)_GH_CONF  := htacg/tidy-html5/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DTIDY_COMPAT_HEADERS:BOOL=YES \
        -DBUILD_SHARED_LIB=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(if $(BUILD_STATIC),
        cd '$(PREFIX)/$(TARGET)/lib' && mv libtidys.a libtidy.a,
        rm -f '$(PREFIX)/$(TARGET)/lib/libtidys.a')
    rm -f '$(PREFIX)/$(TARGET)/bin/tidy.exe'

    # build test manually
    '$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(PWD)/src/$(PKG)-test.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -ltidy
endef
