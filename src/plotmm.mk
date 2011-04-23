# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# PlotMM
PKG             := plotmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.2
$(PKG)_CHECKSUM := 64da0930b7c8994d59769597917cca05df989258
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://$(PKG).sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtkmm2

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/plotmm/files/plotmm/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS=
endef
