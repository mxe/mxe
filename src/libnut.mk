# This file is part of MXE.
# See index.html for further information.

PKG                := libnut
$(PKG)_IGNORE      :=
$(PKG)_VERSIONDATE := 20131109
$(PKG)_VERSIONREV  := r681
$(PKG)_VERSION     := $($(PKG)_VERSIONDATE)-$($(PKG)_VERSIONREV)
$(PKG)_CHECKSUM    := 1be2a8a9dcaed632f23141f2f1230f9a47f05a68
$(PKG)_SUBDIR      := $(PKG)-$($(PKG)_VERSIONREV)
$(PKG)_FILE        := $(PKG)-$($(PKG)_VERSIONREV).tar.xz
$(PKG)_URL         := https://launchpad.net/$(PKG)/trunk/$($(PKG)_VERSIONREV)/+download/$($(PKG)_FILE)
$(PKG)_DEPS        := gcc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libnut need to be written.' >&2;
    echo $(libnut_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' CC='$(TARGET)-gcc' AR='$(TARGET)-ar' RANLIB='$(TARGET)-ranlib' PREFIX='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j 1 install CC='$(TARGET)-gcc' AR='$(TARGET)-ar' RANLIB='$(TARGET)-ranlib' PREFIX='$(PREFIX)/$(TARGET)'
endef
