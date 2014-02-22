# This file is part of MXE.
# See index.html for further information.

PKG             := libgomp
$(PKG)_IGNORE    = $(gcc_IGNORE)
$(PKG)_VERSION   = $(gcc_VERSION)
$(PKG)_CHECKSUM  = $(gcc_CHECKSUM)
$(PKG)_SUBDIR    = $(gcc_SUBDIR)
$(PKG)_FILE      = $(gcc_FILE)
$(PKG)_URL       = $(gcc_URL)
$(PKG)_URL_2     = $(gcc_URL_2)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    echo $(gcc_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(1).build'
    cd       '$(1).build' && '$(1)/libgomp/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --enable-version-specific-runtime-libs \
        --with-gnu-ld \
        --disable-shared \
        LIBS='-lws2_32' \
        ac_cv_prog_FC='$(TARGET)-gfortran'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libgomp.exe' \
        -fopenmp
endef
