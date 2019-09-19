# This file is part of MXE. See LICENSE.md for licensing information.

PKG                     := cargo
$(PKG)_WEBSITE          := https://www.rust-lang.org/
$(PKG)_VERSION          := 0.38.0
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
CHECKSUM_cargo-0.38.0-aarch64-unknown-linux-gnu     :=  ad8ec4973f341a341f8878c9307c63c1f555bc84c1238a494ff1319804e941b7
CHECKSUM_cargo-0.38.0-arm-unknown-linux-gnueabi     :=  17daf6ee9c7223adde051794513e876859fd65f0a01bdb42a97e0c73de20954d
CHECKSUM_cargo-0.38.0-arm-unknown-linux-gnueabihf       :=  8292e067cce9862617b0d0a25e355bd878ecb18ec426742a27826c03f0ca63cd
CHECKSUM_cargo-0.38.0-armv7-unknown-linux-gnueabihf     :=  65b25cd58cb955814028635cce6e2cc3ec684eae7dbdc44db54462dae09e0e8a
CHECKSUM_cargo-0.38.0-i686-apple-darwin     :=  36bcf704c49b6ed033bbefae235a6282f4ecdb0a365086e0e81d23c3080b312d
CHECKSUM_cargo-0.38.0-i686-unknown-freebsd      :=  e1fbbb8d0ccf32c611b110e66b79a8d97acae82e3bac0876bd9b2f85724df9dc
CHECKSUM_cargo-0.38.0-i686-unknown-linux-gnu        :=  a6c3781d8b2bf8619fc2231b01dc73877756c7bbbc1a68c521b9e748b3b7737a
CHECKSUM_cargo-0.38.0-mips-unknown-linux-gnu        :=  75088420e209cf847f0558cc3b1b160ae3055f6d12eeb6fdf60299eef0708df2
CHECKSUM_cargo-0.38.0-mips64-unknown-linux-gnuabi64     :=  17ff46bc026723f0ddb8728ba6718fe7250535b6d789901e9348bff82e4eccde
CHECKSUM_cargo-0.38.0-mips64el-unknown-linux-gnuabi64       :=  fadc235adec83edb15004f68560a0f048ab421ab34dd03d9ecffbbaa6de70aad
CHECKSUM_cargo-0.38.0-mipsel-unknown-linux-gnu      :=  e828539682b74fcc866f26a49515f4fa6c93d7bc4e2df2037bb6597839d30aac
CHECKSUM_cargo-0.38.0-powerpc-unknown-linux-gnu     :=  c39489194624820cda94e0512eb4bffb723e67f2d574c890bb8dd8e30dd6b381
CHECKSUM_cargo-0.38.0-powerpc64-unknown-linux-gnu       :=  fcc3b755e00e029d2b9aaf6acc1be5716bdc75f9fb8036c82130b30183f486bb
CHECKSUM_cargo-0.38.0-powerpc64le-unknown-linux-gnu     :=  8be0c71639c22e18815971079e46e7f3e5bce25365658ca39349e694321b92db
CHECKSUM_cargo-0.38.0-s390x-unknown-linux-gnu       :=  55850a04d70e62de93cecafe8dd33ef152aaf99ad26e96de6a269ee44dbc895a
CHECKSUM_cargo-0.38.0-x86_64-apple-darwin       :=  7a3e48846c9616ccc7dcd641e79b3a08e49dd15f5b134477d52da0615c7146bf
CHECKSUM_cargo-0.38.0-x86_64-unknown-freebsd        :=  8741a4724096f2cff5616baf66ef1ec17efa9b0f62c353bd31d3ccf072a78fce
CHECKSUM_cargo-0.38.0-x86_64-unknown-linux-gnu      :=  a3ba2df5e21aaba70e40bd289e4b3bab3df516c4e374c7178d3762338949df56
CHECKSUM_cargo-0.38.0-x86_64-unknown-linux-musl     :=  84fba8b477aa966519994d2b61611fd13483e99c90642fd544ee59df10a05634
CHECKSUM_cargo-0.38.0-x86_64-unknown-netbsd     :=  7296e328943e22145461f839b4990b5701db2024414aba5710445ca6ced5dc74

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