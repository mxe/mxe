# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := smpeg
$(PKG)_WEBSITE  := https://icculus.org/smpeg/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.5+cvs20030824
$(PKG)_CHECKSUM := 1276ea797dd9fde8a12dd3f33f180153922544c28ca9fc7b477c018876be1916
$(PKG)_SUBDIR   := smpeg-$($(PKG)_VERSION).orig
$(PKG)_FILE     := smpeg_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_URL      := https://deb.debian.org/debian/pool/main/s/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://packages.debian.org/unstable/source/smpeg' | \
    $(SED) -n 's,.*smpeg_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\(-lsmpeg\),\1 -lstdc++,' '$(SOURCE_DIR)/smpeg-config.in'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(subst docdir$(comma),,$(MXE_CONFIGURE_OPTS)) \
        AR='$(TARGET)-ar' \
        NM='$(TARGET)-nm' \
        --disable-debug \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-gtk-player \
        --disable-opengl-player \
        CFLAGS='-ffriend-injection -Wno-narrowing'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)

    $(if $(BUILD_SHARED),\
        rm -f '$(PREFIX)/$(TARGET)/lib/libsmpeg.a' && \
        $(MAKE_SHARED_FROM_STATIC) '$(BUILD_DIR)/.libs/libsmpeg.a' \
        --ld '$(TARGET)-g++' \
        `$(PREFIX)/$(TARGET)/bin/smpeg-config --libs | $(SED) -e 's/-L[^ ]*//g' -e 's/-lsmpeg//g'`)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-smpeg.exe' \
        `'$(PREFIX)/$(TARGET)/bin/smpeg-config' --cflags --libs`
endef
