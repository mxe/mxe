# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgsasl
$(PKG)_WEBSITE  := https://www.gnu.org/software/gsasl/
$(PKG)_DESCR    := Libgsasl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.4
$(PKG)_CHECKSUM := d32be15efd3a04cb19b232f721bdca02cc6ad7ab415df7d79fb2dd2c0da3e0be
$(PKG)_SUBDIR   := gsasl-$($(PKG)_VERSION)
$(PKG)_FILE     := gsasl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gsasl/$($(PKG)_FILE)
$(PKG)_URL_2    := https://download.savannah.nongnu.org/releases/gsasl/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libiconv libidn libntlm

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://ftp.gnu.org/gnu/gsasl/, gsasl-)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --with-libgcrypt \
        --with-libgcrypt-prefix='$(PREFIX)/$(TARGET)' \
        --with-libiconv-prefix='$(PREFIX)/$(TARGET)' \
        --with-libidn-prefix='$(PREFIX)/$(TARGET)' \
        --with-libntlm-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libgsasl.exe' \
        `'$(TARGET)-pkg-config' libgsasl --cflags --libs`
endef
