# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := vvdec
$(PKG)_WEBSITE  := https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html
$(PKG)_DESCR    := VVdeC, the Fraunhofer Versatile Video Decoder
$(PKG)_VERSION  := 3.1.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e3e5093acfdcbfd2159f3d0166d451d7ccabd293ed30f3762b481c9c6c0a7512
$(PKG)_GH_CONF  := fraunhoferhhi/vvdec/tags,v
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_SHARED_LIBS=OFF \
		-DVVDEC_ENABLE_BITSTREAM_DOWNLOAD=OFF \
		-DVVDEC_ENABLE_BUILD_TYPE_POSTFIX=OFF \
		-DVVDEC_ENABLE_ITT=OFF \
		-DVVDEC_ENABLE_LINK_TIME_OPT=ON \
		-DVVDEC_ENABLE_LOCAL_BITSTREAM_DOWNLOAD=OFF \
		-DVVDEC_ENABLE_TRACING=FALSE \
		-DVVDEC_ENABLE_UNSTABLE_API=OFF \
		-DVVDEC_ENABLE_WERROR=ON \
		-DVVDEC_ENABLE_X86_SIMD=TRUE \
		-DVVDEC_INSTALL_VVDECAPP=OFF \
		-DVVDEC_LIBRARY_ONLY=OFF \
		-DVVDEC_TOPLEVEL_OUTPUT_DIRS=ON \
		-DVVDEC_USE_ADDRESS_SANITIZER=OFF \
		-DVVDEC_USE_THREAD_SANITIZER=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "lib$(PKG)" --cflags --libs`
endef
