# This file is part of MXE.
# See index.html for further information.

PKG             := texinfo
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a1533cf8e03ea4fa6c443b73f4c85e4da04dead0
$(PKG)_SUBDIR   := $(PKG)-4.13
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := libgnurx

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package texinfo.' >&2;
    echo $(texinfo_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)'

    ## All we need for Octave is makeinfo.
    $(MAKE) -C '$(1)/.build/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build/gnulib/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build/makeinfo' -j '$(JOBS)' install
endef
