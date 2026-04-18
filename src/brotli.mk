# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := brotli
$(PKG)_WEBSITE  := https://brotli.org/
$(PKG)_DESCR    := Brotli compression format
$(PKG)_VERSION  := 1.2.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 816c96e8e8f193b40151dad7e8ff37b1221d019dbcb9c35cd3fadbfe6477dfec
$(PKG)_GH_CONF  := google/brotli/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBROTLI_BUILD_FOR_PACKAGE=OFF \
		-DBROTLI_BUILD_TOOLS=ON \
		-DBUILD_TESTING=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# brotli alraedy compiles a test program into the prefix: brotli.exe
endef
