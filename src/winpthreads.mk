# This file is part of MXE.
# See index.html for further information.

PKG             := winpthreads
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := d86e21b33eea05ff2c27b428eaab679d7ab3b08e
$(PKG)_SUBDIR   := tonytheodore-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/tonytheodore/$(PKG)/tarball/$($(PKG)_VERSION)/$(PKG)_FILE
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'info: sync latest winpthreads with git svn rebase; git push origin master' >&2;
    $(WGET) -q -O- 'https://github.com/tonytheodore/$(PKG)/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_BUILD_mingw-w64
    cd '$(1)' && ./configure \
        $(LINK_STYLE) \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    $(PTHREADS_TEST)
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $($(PKG)_BUILD_mingw-w64)
$(PKG)_BUILD_i686-w64-mingw32   = $($(PKG)_BUILD_mingw-w64)
