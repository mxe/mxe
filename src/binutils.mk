# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := binutils
$(PKG)_WEBSITE  := https://www.gnu.org/software/binutils/
$(PKG)_DESCR    := GNU Binutils
$(PKG)_VERSION  := 2.32
$(PKG)_CHECKSUM := 0ab6c55dd86a92ed561972ba15b9b70a8b9f75557f896446c82e8b36e473ee04
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_DISABLE_DOC_OPTS) \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --disable-multilib \
        --enable-deterministic-archives \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --disable-werror
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    rm -f $(addprefix $(PREFIX)/$(TARGET)/bin/, ar as dlltool ld ld.bfd nm objcopy objdump ranlib readelf strip)
endef
