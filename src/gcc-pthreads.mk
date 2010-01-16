# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# Pthreads-w32 for GCC
PKG             := gcc-pthreads
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2-8-0
$(PKG)_CHECKSUM := da8371cb20e8e238f96a1d0651212f154d84a9ac
$(PKG)_SUBDIR   := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE     := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_WEBSITE  := http://sourceware.org/pthreads-win32/
$(PKG)_URL      := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'ftp://sourceware.org/pub/pthreads-win32/Release_notes' | \
    $(SED) -n 's,^RELEASE \([0-9][^[:space:]]*\).*,\1,p' | \
    tr '.' '-' | \
    head -1
endef
