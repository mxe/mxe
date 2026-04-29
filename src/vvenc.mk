# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := vvenc
$(PKG)_WEBSITE  := https://github.com/fraunhoferhhi/VVenC.git
$(PKG)_DESCR    := VVenC, the Fraunhofer Versatile Video Encoder
$(PKG)_VERSION  := 1.14.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := dd43d061d59dbc0d9b9ae5b99cb40672877dd811646228938f065798939ee174
$(PKG)_GH_CONF  := fraunhoferhhi/VVenC/tags,v
$(PKG)_SUBDIR   := vvenc-1.14.0
$(PKG)_DEPS     := cc pthreads nlohmann_json

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_SHARED_LIBS=OFF \
		-DVVENC_ENABLE_ARM_SIMD_SVE2=FALSE \
		-DVVENC_ENABLE_BUILD_TYPE_POSTFIX=OFF \
		-DVVENC_ENABLE_INSTALL=ON \
		-DVVENC_ENABLE_LINK_TIME_OPT=ON \
		-DVVENC_ENABLE_TRACING=OFF \
		-DVVENC_ENABLE_UNSTABLE_API=OFF \
		-DVVENC_ENABLE_WERROR=ON \
		-DVVENC_ENABLE_X86_SIMD=TRUE \
		-DVVENC_FFP_CONTRACT_OFF=OFF \
		-DVVENC_INSTALL_FULLFEATURE_APP=OFF \
		-DVVENC_LIBRARY_ONLY=OFF \
		-DVVENC_TOPLEVEL_OUTPUT_DIRS=ON \
		-DVVENC_USE_ADDRESS_SANITIZER=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# vvenc already compiles a test program "vvencapp.exe" test with .\vvencapp.exe --version
endef
