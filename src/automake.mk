# This file is part of MXE.
# See index.html for further information.

PKG             := automake
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 72ee9fcd180c54fd7c067155d85fa071a99c3ea3
$(PKG)_SUBDIR   := automake-$($(PKG)_VERSION)
$(PKG)_FILE     := automake-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/automake/$($(PKG)_FILE)
$(PKG)_DEPS     := autoconf

define $(PKG)_UPDATE
    echo 'Warning: Updates are disabled for package automake.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD_NATIVE
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/native'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
