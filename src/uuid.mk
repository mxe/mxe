# This file is part of MXE.
# See index.html for further information.

PKG             := uuid
$(PKG)_IGNORE   = $(w32api_IGNORE)
$(PKG)_VERSION  := 3.17
$(PKG)_CHECKSUM = $(w32api_CHECKSUM)
$(PKG)_SUBDIR   = $(w32api_SUBDIR)
$(PKG)_FILE     = $(w32api_FILE)
$(PKG)_URL      = $(w32api_URL)
$(PKG)_DEPS     =

define $(PKG)_UPDATE
    echo "$(w32api_VERSION)"
endef

define $(PKG)_BUILD
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(HOST_BINDIR)'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(1)/lib/libuuid.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
      rm -f '$(HOST_LIBDIR)/libuuid.dll.a'; \
    fi
endef
