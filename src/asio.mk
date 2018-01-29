# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := asio
$(PKG)_WEBSITE  := http://think-async.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10.8
$(PKG)_CHECKSUM := 26deedaebbed062141786db8cfce54e77f06588374d08cccf11c02de1da1ed49
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION) (Stable)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 boost
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/asio/rss/' | \
    $(SED) -n 's,.*(Stable)/asio-\([0-9][^"]*\).tar.*,\1,p' | \
    uniq | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
      --host='$(TARGET)' \
      --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
