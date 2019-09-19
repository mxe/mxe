# This file is part of MXE. See LICENSE.md for licensing information.

PKG                     := rust-std-bootstrap
$(PKG)_BASE             := $(subst -bootstrap,,$(PKG))
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
$(PKG)_FILE             := $($(PKG)_BASE)-$($(PKG)_VERSION)-$(BUILD_TRIPLET).tar.xz
$(PKG)_URL              := https://static.rust-lang.org/dist/$($(PKG)_FILE)

# CHECKSUMS
CHECKSUM_rust-std-1.37.0-aarch64-unknown-linux-gnu      :=  eb0105a56563112ac841171d94d92ce1e7da1e7affa26488c04cb1dbe822c76b
CHECKSUM_rust-std-1.37.0-arm-unknown-linux-gnueabi      :=  7f1b5ccc166227e470d5da4729a05841e76b29354e3e935ed0b3987711e4b69f
CHECKSUM_rust-std-1.37.0-arm-unknown-linux-gnueabihf        :=  dd70092a71fd1b38f826156b4a0097d86a345850c73de904592a42a00e0cf3e0
CHECKSUM_rust-std-1.37.0-armv7-unknown-linux-gnueabihf      :=  727e6132033eedd1c4d60765f858a36e4b395c91417cea1c635c27374a94ab2b
CHECKSUM_rust-std-1.37.0-i686-apple-darwin      :=  290f963447c0f15a4cc165499a0076848b7c7b88c88d3a228a2c0dbf810b6eba
CHECKSUM_rust-std-1.37.0-i686-unknown-freebsd       :=  61fb3424319cd320e0ea6aeb0084fc4211656265254e740233e330f996158b31
CHECKSUM_rust-std-1.37.0-i686-unknown-linux-gnu     :=  420215f355a082bd8273ab5f92e1e9c10e277a8773807020549949ee3b95b566
CHECKSUM_rust-std-1.37.0-mips-unknown-linux-gnu     :=  c9bada4d39d868b32be2a83f7290b175ee8d64727998adf1a98577c44423405f
CHECKSUM_rust-std-1.37.0-mips64-unknown-linux-gnuabi64      :=  a51aa953790037894849ae3f1f09de2a347d50eaa5ae9af1317047bee1ea3aef
CHECKSUM_rust-std-1.37.0-mips64el-unknown-linux-gnuabi64        :=  a395ae36331700bad8dbc1eb370fcb5f639a2a1877c5ce031732d12c7fc4a8d8
CHECKSUM_rust-std-1.37.0-mipsel-unknown-linux-gnu       :=  ad737c57ecf75a3f90c0e902ac13aa62dfd697d9e09ffc962f71ee82e490d364
CHECKSUM_rust-std-1.37.0-powerpc-unknown-linux-gnu      :=  8e2cb813df975fe6a2e728757e373c32b8689077585514860be0218d90f860cd
CHECKSUM_rust-std-1.37.0-powerpc64-unknown-linux-gnu        :=  2761bee0ff224ebce4b500bcf0b21f1ca8b800b3fb9acfdcf9875f9ba0d79fc4
CHECKSUM_rust-std-1.37.0-powerpc64le-unknown-linux-gnu      :=  8939ead9e9b6adea8b5bb3365fec7c2b5420e5d0b1c595fafa7d8b1fc5cf429f
CHECKSUM_rust-std-1.37.0-s390x-unknown-linux-gnu        :=  828e9df85e7eac189a3fcc4c1ec0affa54d128c6fe873b76ac74b33f13135bea
CHECKSUM_rust-std-1.37.0-x86_64-apple-darwin        :=  8fe94b20ede22b768d86c0fb29c9dd17dda30f7ab411b5c540654ea1ae8ebb20
CHECKSUM_rust-std-1.37.0-x86_64-unknown-freebsd     :=  262d294a1b71712118c14acdd43198ef958a5e95ba5da0b3b46153a8e959cb22
CHECKSUM_rust-std-1.37.0-x86_64-unknown-linux-gnu       :=  f8090dbd8a2dda674f8832f7999758b248028453465bf83f797569e28065fdbc
CHECKSUM_rust-std-1.37.0-x86_64-unknown-linux-musl      :=  985d511eb43c1083f5961c0dfb953cd01c0818a7200593fade278cde7502f836
CHECKSUM_rust-std-1.37.0-x86_64-unknown-netbsd      :=  2bea6c1e9b60dae314721307cfb15db9718cb970e1f2944ac41974faf77ea0d5

$(PKG)_CHECKSUM         := $(CHECKSUM_$($(PKG)_BASE)-$($(PKG)_VERSION)-$(BUILD_TRIPLET))
$(PKG)_TARGETS          := $(BUILD)

define $(PKG)_UPDATE
    stable_date := $(shell curl https://static.rust-lang.org/dist/channel-rust-stable-date.txt)
    $(WGET) -q -O- 'https://static.rust-lang.org/dist/$(stable_date)/' | \
    $(SED) -n 's,.*$($(PKG)_BASE)-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|git\|nightly' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    $(SOURCE_DIR)/$($(PKG)_BASE)-$($(PKG)_VERSION)-$(BUILD_TRIPLET)/install.sh --prefix=$(PREFIX)/$(BUILD) --verbose
endef