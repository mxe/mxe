# This file is part of MXE. See LICENSE.md for licensing information.

PKG                     := rustc
$(PKG)_WEBSITE          := https://www.rust-lang.org/
$(PKG)_VERSION          := 1.37.0
$(PKG)_DEPS_$(BUILD)    := cc

ifneq (, $(findstring darwin,$(BUILD)))
    BUILD_TRIPLET = $(firstword $(call split,-,$(BUILD)))-apple-darwin
else
    ifneq (, $(findstring ibm-linux,$(BUILD)))
        BUILD_TRIPLET = $(firstword $(call split,-,$(BUILD)))-unknown-linux-gnu
    else
        BUILD_TRIPLET = $(BUILD)
    endif
endif

TARGET_TRIPLET          = $(firstword $(call split,-,$(TARGET)))-pc-windows-gnu
$(PKG)_FILE             := $(PKG)-$($(PKG)_VERSION)-$(BUILD_TRIPLET).tar.xz
$(PKG)_URL              := https://static.rust-lang.org/dist/$($(PKG)_FILE)

# CHECKSUMS
CHECKSUM_rustc-1.37.0-aarch64-unknown-linux-gnu     :=  8e06a483a5764f687db8e352591ab651c7a78e3be06af2d2a4f33d6c9b158c59
CHECKSUM_rustc-1.37.0-arm-unknown-linux-gnueabi     :=  d6c3ec6474501d40cdf90e84f5308f0eb09a4f03fea9214df1f5eea0b9b8013e
CHECKSUM_rustc-1.37.0-arm-unknown-linux-gnueabihf       :=  0b03246d21a1618aa2cba7ec09eae03694f76943ae58a5f3eaea646f16022a26
CHECKSUM_rustc-1.37.0-armv7-unknown-linux-gnueabihf     :=  d5a8a2fd71ca8bafb930b0eb9d23231131a6f992640885ba4976d6955948efd2
CHECKSUM_rustc-1.37.0-i686-apple-darwin     :=  65e23eda010f8a3287d527bc67226f3a5276e43bc3eadd99112c8041794e2385
CHECKSUM_rustc-1.37.0-i686-unknown-freebsd      :=  2559d79557ddeccdedcef9b592655be67bda21ebcdbd7773572927fe62c1becb
CHECKSUM_rustc-1.37.0-i686-unknown-linux-gnu        :=  f0d7740264040663a0afca19b1c597dda81ef71b7489cbf675116241fedf3637
CHECKSUM_rustc-1.37.0-mips-unknown-linux-gnu        :=  cc699d06f0da4d7da230534ee870889200c7c75ec1403ff4eba3679249420a49
CHECKSUM_rustc-1.37.0-mips64-unknown-linux-gnuabi64     :=  5f64ab1649f4a30dfc445e7aa59e88c7d95883474ff8381250555941429c69be
CHECKSUM_rustc-1.37.0-mips64el-unknown-linux-gnuabi64       :=  d8a23cecfed41dbe5bf2e18945ee72d91a0155cf41ed99bbf277cf7a3e0e6887
CHECKSUM_rustc-1.37.0-mipsel-unknown-linux-gnu      :=  a0971cd1af153784164ed3e644b80a524f8271f0d6b787a5e4ce547780a8aa54
CHECKSUM_rustc-1.37.0-powerpc-unknown-linux-gnu     :=  ecff5acba4a06c3b29fedf618364b054318f5a873849bde1fa81d8397faf2bc1
CHECKSUM_rustc-1.37.0-powerpc64-unknown-linux-gnu       :=  83bc3022b3874961163933f493f4ba1d37b43f737d832d9f5f031e5f3651d765
CHECKSUM_rustc-1.37.0-powerpc64le-unknown-linux-gnu     :=  40ff4c1da1ffc685033ca6b9a618588cd4fa5bdc135efea585efeb2b069057d0
CHECKSUM_rustc-1.37.0-s390x-unknown-linux-gnu       :=  1edc7ae7a7dbcffa7eb65341806b0f2cad15a5c571ee6786175572bda5dd5380
CHECKSUM_rustc-1.37.0-x86_64-apple-darwin       :=  403b1ee63235b6a196a6eb99f315b05ce007558cc7041150251354cfbf734f07
CHECKSUM_rustc-1.37.0-x86_64-unknown-freebsd        :=  077509f49f3546bef943476387e1a9b22f4a42544841b17e5997900179be35be
CHECKSUM_rustc-1.37.0-x86_64-unknown-linux-gnu      :=  7014f34578a0bbfffc09bf53d536e29f4ec37bfc48a579d372a340b4d6763416
CHECKSUM_rustc-1.37.0-x86_64-unknown-linux-musl     :=  b2edb942f73604973f7281e1d51629f75274ed64394edaba55ea9f35cc3c66de
CHECKSUM_rustc-1.37.0-x86_64-unknown-netbsd     :=  3e88d16311618280b6119cc055864b180724d0fbd46c26d5b5cc21e6dc3d3199

$(PKG)_CHECKSUM         := $(CHECKSUM_$(PKG)-$($(PKG)_VERSION)-$(BUILD_TRIPLET))
$(PKG)_TARGETS          := $(BUILD)

define $(PKG)_UPDATE
    stable_date := $(shell curl https://static.rust-lang.org/dist/channel-rust-stable-date.txt)
    $(WGET) -q -O- 'https://static.rust-lang.org/dist/$(stable_date)/' | \
    $(SED) -n 's,.*$(PKG)-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|git\|nightly' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    $(SOURCE_DIR)/$(PKG)-$($(PKG)_VERSION)-$(BUILD_TRIPLET)/install.sh --prefix=$(PREFIX)/$(BUILD) --verbose
endef