# This file is part of MXE.
# See index.html for further information.

PKG             := tlspool
$(PKG)_VERSION  := 0.19
$(PKG)_CHECKSUM := 9c43077e1eaf96539f03aa1ebe7b5e8a1727306529c0318bf88054f604a9fad8
$(PKG)_SUBDIR   := $(PKG)-version-$($(PKG)_VERSION)-beta1
$(PKG)_FILE     := $(PKG)-version-$($(PKG)_VERSION)-beta1.tar.gz
$(PKG)_URL      := https://github.com/arpa2/$(PKG)/archive/version-$($(PKG)_VERSION)-beta1.tar.gz
$(PKG)_DEPS     := gcc pthreads p11-kit libtasn1 db quick-der ldns unbound

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

$(PKG)_MAKE_OPTS = \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CROSS_SUFFIX='$(TARGET)-' \
        CC='$(TARGET)-gcc' \
		PKG_CONFIG='$(TARGET)-pkg-config' \
		DLLTOOL='$(TARGET)-dlltool' \
        HOSTCC='$(BUILD_CC)' \
        WINVER=0x0600 \
		SBIN=bin

define $(PKG)_BUILD
    $(MAKE)  -C '$(1)/src' -j '$(JOBS)' install $($(PKG)_MAKE_OPTS)
    $(MAKE)  -C '$(1)/lib' -j '$(JOBS)' install $($(PKG)_MAKE_OPTS)
endef
