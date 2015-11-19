# This file is part of MXE.
# See index.html for further information.

PKG             := pire
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := 8cfe1c97e54539c5751dcbcddc3b15610cf43fd8458ed821450cac7b2ad6b2f9
$(PKG)_DEPS     := gcc

$(PKG)_GH_REPO    := yandex/pire
$(PKG)_GH_TAG_PFX := release-
$(PKG)_GH_TAG_SHA := 012bedf
$(eval $(MXE_SETUP_GITHUB))

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-extra \
        ac_cv_func_malloc_0_nonnull=yes
    $(MAKE) -C '$(1)/pire' -j '$(JOBS)' bin_PROGRAMS= LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)/pire' -j 1 install bin_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(1)/samples/pigrep/pigrep.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lpire
endef
