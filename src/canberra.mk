# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := canberra
$(PKG)_WEBSITE  := http://0pointer.de/lennart/projects/libcanberra/
$(PKG)_DESCR    := libcanberra
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.30
$(PKG)_CHECKSUM := c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72
$(PKG)_SUBDIR   := libcanberra-$($(PKG)_VERSION)
$(PKG)_FILE     := libcanberra-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://0pointer.de/lennart/projects/libcanberra/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libltdl vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://0pointer.de/lennart/projects/libcanberra/' | \
    $(SED) -n 's,.*libcanberra-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-lynx \
        --disable-pulse \
        --disable-alsa \
        --disable-oss \
        --disable-gstreamer \
        --enable-null \
        --disable-gtk \
        --disable-gtk3 \
        --disable-tdb \
        --disable-udev \
        --enable-builtin-null
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    
    $(SED) -i 's/^Libs:.*/& -lltdl/g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/libcanberra.pc'
endef
