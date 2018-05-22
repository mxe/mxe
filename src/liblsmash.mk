# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblsmash
$(PKG)_WEBSITE  := https://l-smash.github.io/l-smash/
$(PKG)_DESCR    := L-SMASH
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.14.5
$(PKG)_CHECKSUM := e6f7c31de684f4b89ee27e5cd6262bf96f2a5b117ba938d2d606cf6220f05935
$(PKG)_GH_CONF  := l-smash/l-smash/tags, v
$(PKG)_DEPS     := cc

# L-SMASH uses a custom made configure script that doesn't recognize
# the option --host and fails on unknown options.
# Therefor $(MXE_CONFIGURE_OPTS) can't be used here.
define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix=$(TARGET)- \
        $(if $(BUILD_SHARED), --enable-shared --disable-static)
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
endef
