# This file is part of MXE.
# See index.html for further information.

PKG             := cpp-netlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11.1
$(PKG)_CHECKSUM := 0b0261d67a807804c2b1c994b5b8996a8ec76a02
$(PKG)_SUBDIR   := cpp-netlib-$($(PKG)_VERSION)-final
$(PKG)_FILE     := cpp-netlib-$($(PKG)_VERSION)-final.tar.gz
$(PKG)_URL      := http://storage.googleapis.com/cpp-netlib-downloads/$($(PKG)_VERSION)/cpp-netlib-$($(PKG)_VERSION)-final.tar.gz
$(PKG)_DEPS     := gcc boost

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD
	mkdir '$(1)/build'
	cd '$(1)/build' && cmake .. \
		-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
		-DCPP-NETLIB_BUILD_EXAMPLES=OFF \
		-DCPP-NETLIB_BUILD_TESTS=OFF

	$(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
