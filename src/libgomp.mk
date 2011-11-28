# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GCC-libgomp
PKG             := libgomp
$(PKG)_IGNORE    = $(gcc_IGNORE)
$(PKG)_VERSION   = $(gcc_VERSION)
$(PKG)_CHECKSUM  = $(gcc_CHECKSUM)
$(PKG)_SUBDIR    = $(gcc_SUBDIR)
$(PKG)_FILE      = $(gcc_FILE)
$(PKG)_WEBSITE  := http://gcc.gnu.org/projects/gomp/
$(PKG)_URL       = $(gcc_URL)
$(PKG)_URL_2     = $(gcc_URL_2)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    echo $(gcc_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(1)/build/$(TARGET)/libgomp'
    cd       '$(1)/build/$(TARGET)/libgomp' && '$(1)/libgomp/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --enable-version-specific-runtime-libs \
        --with-gnu-ld \
        --disable-shared \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libgomp.exe' \
        -fopenmp
endef
