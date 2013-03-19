# This file is part of MXE.
# See index.html for further information.

PKG             := arpack
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f5453e2d576f131890ca023e1d853e18920f9c3c
$(PKG)_SUBDIR   := $(PKG)-ng_$($(PKG)_VERSION)
$(PKG)_FILE     := arpack-ng_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/$($(PKG)_FILE)
$(PKG)_DEPS     := blas lapack

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package arpack.' >&2;
    echo $(arpack_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gfortran' '$(PREFIX)/$(TARGET)/lib/libarpack.a' -llapack -lblas; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libarpack.dll.a' '$(PREFIX)/$(TARGET)/lib/libarpack.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libarpack.dll' '$(PREFIX)/$(TARGET)/bin/libarpack.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libarpack.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libarpack.la'; \
    fi
endef
