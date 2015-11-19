# This file is part of MXE.
# See index.html for further information.

PKG             := librtmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := a1900c3
$(PKG)_CHECKSUM := fa4edd83cb6ed19d97f89a6d83aef6231c1bd8079aea5d33c083f827459a9ab2
$(PKG)_DEPS     := gcc gnutls

$(PKG)_GH_REPO   := mirror/rtmpdump
$(PKG)_GH_BRANCH := master
$(eval $(MXE_SETUP_GITHUB))

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
