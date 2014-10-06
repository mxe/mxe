# This file is part of MXE.
# See index.html for further information.

PKG             := picomodel
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1142ad8
$(PKG)_CHECKSUM := b82b16ee69edaefe751b678b577b90c1971ce4db
$(PKG)_SUBDIR   := ufoai-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/ufoai/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, ufoai/picomodel, master)

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
