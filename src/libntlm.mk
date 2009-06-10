# Libntlm

PKG             := libntlm
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := d7608bea4820cdf879a5b10bc956391fb3973f08
$(PKG)_SUBDIR   := libntlm-$($(PKG)_VERSION)
$(PKG)_FILE     := libntlm-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://josefsson.org/libntlm/
$(PKG)_URL      := http://josefsson.org/libntlm/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=libntlm.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^>]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
