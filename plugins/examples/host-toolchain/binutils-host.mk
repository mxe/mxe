# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := binutils-host
$(PKG)_IGNORE    = $(binutils_IGNORE)
$(PKG)_VERSION   = $(binutils_VERSION)
$(PKG)_CHECKSUM  = $(binutils_CHECKSUM)
$(PKG)_SUBDIR    = $(binutils_SUBDIR)
$(PKG)_FILE      = $(binutils_FILE)
$(PKG)_URL       = $(binutils_URL)
$(PKG)_URL_2     = $(binutils_URL_2)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo $(binutils_VERSION)
endef

$(PKG)_PROGS := addr2line ar as c++filt dlltool dllwrap elfedit gprof \
                ld.bfd ld nm objcopy objdump ranlib readelf size strings \
                strip windmc windres

define $(PKG)_BUILD
    $(subst --disable-werror,\
            --disable-werror \
            --prefix='$(PREFIX)/$(TARGET)' \
            --program-prefix='$(TARGET)-' \
            --host='$(TARGET)',\
    $(binutils_BUILD))

    # install unprefixed versions also
    for p in $($(PKG)_PROGS); do \
        cp "$(PREFIX)/$(TARGET)/bin/$(TARGET)-$$p.exe" \
           "$(PREFIX)/$(TARGET)/bin/$$p.exe" ; \
    done

    # tools seem to be duplicates of '$(PREFIX)/$(TARGET)'
    rm -rf '$(PREFIX)/$(TARGET)/$(TARGET)'
endef
