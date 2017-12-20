# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := p11-kit
$(PKG)_WEBSITE  := https://p11-glue.freedesktop.org/p11-kit.html
$(PKG)_DESCR    := using pkcs 11 to unite crypto libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23.9
$(PKG)_CHECKSUM := e1c1649c335107a8d33cf3762eb7f57b2d0681f0c7d8353627293a58d6b4db63
$(PKG)_GH_CONF  := p11-glue/p11-kit
$(PKG)_URL      := https://github.com/$($(PKG)_GH_CONF)/releases/download/$($(PKG)_VERSION)/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc gettext libtasn1 libffi

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --without-trust-paths
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG)-1 --cflags --libs`
endef

# static builds deliberately disabled for all systems
# https://github.com/p11-glue/p11-kit/commit/7370d64c18b795a63eda40efcc9e786b821cb7f7
$(PKG)_BUILD_STATIC :=
