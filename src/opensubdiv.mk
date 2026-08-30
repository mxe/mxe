# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := opensubdiv
$(PKG)_WEBSITE  := https://www.opensubdiv.org
$(PKG)_DESCR    := High-performance subdivision surface library for generating smooth meshes from polygon geometry.
$(PKG)_VERSION  := 3_7_0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f843eb49daf20264007d807cbc64516a1fed9cdb1149aaf84ff47691d97491f9
$(PKG)_GH_CONF  := PixarAnimationStudios/OpenSubdiv/tags,v
$(PKG)_DEPS     := cc onetbb zlib glfw3 clew cuew ptex

define $(PKG)_BUILD

	cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
		-DCLEW_LIBRARY='$(PREFIX)/$(TARGET)/lib/libclew.a' \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
		-DOPENSUBDIV_PTEX_SUPPORT=OFF \
		-DNO_DX=ON \
		-DNO_OPENCL=ON \
		-DNO_CUDA=ON \
		-DNO_PTEX=OFF \
		-DNO_REGRESSION=ON \
		-DNO_EXAMPLES=ON \
		-DNO_TUTORIALS=ON \
		-DNO_DOC=OFF \
		-DNO_OPENGL=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# Only needed if the project does not ship a .pc file
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		$(PKG), \
		$($(PKG)_DESC), \
		$($(PKG)_VERSION), \
		, \
		tbb zlib clew cuew ptex, \
		-losdCPU, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
