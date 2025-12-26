# This file is part of MXE.
# See index.html for further information.

PKG             := pexports
$(PKG)_WEBSITE  := http://www.mingw.org/
$(PKG)_DESCR    := pexports
$(PKG)_VERSION  := 0.47
$(PKG)_CHECKSUM := fe12853979bd7335aa771c934ddee913c987554f9dc11266262b7fd68e0aa884
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-mingw32-src.tar.xz
$(PKG)_URL      := https://sourceforge.net/projects/mingw/files/MinGW/Extension/$(PKG)/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mingw.org/' | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && autoreconf -fi

    cd '$(1)' && ./configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        $(MXE_CONFIGURE_OPTS)

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' install

endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef

