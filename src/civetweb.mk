# This file is part of MXE. See LICENSE.md for licensing information.

PKG             		 := civetweb
$(PKG)_WEBSITE  		 := https://github.com/civetweb/civetweb
$(PKG)_DESCR    		 := Embedded C/C++ web server
$(PKG)_IGNORE   		 :=
$(PKG)_VERSION  		 := 1.15
$(PKG)_CHECKSUM 		 := 90a533422944ab327a4fbb9969f0845d0dba05354f9cacce3a5005fa59f593b9
$(PKG)_GH_CONF  		 := civetweb/civetweb/tags,v
$(PKG)_DEPS			     := zlib openssl
#$(PKG)_DEPS_$(BUILD) := cmake

define $(PKG)_BUILD
		cd '$(BUILD_DIR)' && \
			$(TARGET)-cmake '$(SOURCE_DIR)' -DCIVETWEB_BUILD_TESTING=OFF -DCIVETWEB_ENABLE_CXX=ON -DCIVETWEB_ENABLE_IPV6=ON -DCIVETWEB_DISABLE_CGI=ON -DCIVETWEB_ENABLE_ZLIB=ON -DCIVETWEB_ENABLE_SSL=ON -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' -D_WIN32_WINNT=0x0600 -DWINSOCK_LIBRARIES='$(PREFIX)/$(TARGET)/lib/libws2_32.a' && \
			$(TARGET)-cmake --build . --parallel '$(JOBS)' && \
			$(TARGET)-cmake --install .
endef
