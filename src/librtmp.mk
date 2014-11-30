# This file is part of MXE.
# See index.html for further information.

PKG             := librtmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := a1900c3
$(PKG)_CHECKSUM := ca1738708ce799226626326f46c416dbda346514
$(PKG)_SUBDIR   := mirror-rtmpdump-$($(PKG)_VERSION)
$(PKG)_FILE     := rtmpdump-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/rtmpdump/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls

$(PKG)_UPDATE = $(call MXE_GET_GITHUB_SHA, mirror/rtmpdump, master)

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' \
        CROSS_COMPILE='$(TARGET)-' \
        prefix='$(PREFIX)/$(TARGET)' \
        SYS=mingw \
        CRYPTO=GNUTLS \
        $(if $(BUILD_STATIC),\
            SHARED=no \
            LIB_GNUTLS="`$(TARGET)-pkg-config --libs-only-l gnutls`",) \
        -j '$(JOBS)' install
endef
