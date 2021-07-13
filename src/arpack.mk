# This file is part of MXE.
# See index.html for further information.

PKG             := arpack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.0
$(PKG)_CHECKSUM := 50f7a3e3aec2e08e732a487919262238f8504c3ef927246ec3495617dde81239
$(PKG)_SUBDIR   := $(PKG)-ng-$($(PKG)_VERSION)
$(PKG)_FILE     := arpack-ng_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/opencollab/arpack-ng/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := lapack blas

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/opencollab/arpack-ng/releases' | \
    $(SED) -n 's,.*href="/opencollab/arpack-ng/archive/\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(1)/bootstrap'
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gfortran' '$(PREFIX)/$(TARGET)/lib/libarpack.a' -llapack -lblas; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libarpack.dll.a' '$(PREFIX)/$(TARGET)/lib/libarpack.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libarpack.dll' '$(PREFIX)/$(TARGET)/bin/libarpack.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libarpack.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libarpack.la'; \
    fi
endef
