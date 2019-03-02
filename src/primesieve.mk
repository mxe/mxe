# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := primesieve
$(PKG)_WEBSITE  := https://primesieve.org/
$(PKG)_DESCR    := Primesieve
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.3
$(PKG)_CHECKSUM := bbf4a068ba220a479f3b6895513a85ab25f6b1dcbd690b188032c2c3482ef050
$(PKG)_GH_CONF  := kimwalisch/primesieve/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0601' .
    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)' -j 1 install

    $(TARGET)-g++ -s -std=c++0x -fopenmp -o '$(1)/examples/test-primesieve.exe' \
        '$(1)/examples/cpp/count_primes.cpp' \
        '-lprimesieve'
    $(INSTALL) -m755 '$(1)/examples/test-primesieve.exe' '$(PREFIX)/$(TARGET)/bin/'

endef
