# This file is part of MXE. See LICENSE.md for licensing information.
$(PLUGIN_HEADER)

# override relevant variables to build against frozen v1.0.x series

dcmtk_CONFIGURE_OPTS := --with-openssl

vmime_DEPS    := $(filter-out gnutls,$(vmime_DEPS)) openssl
vmime_TLS_LIB := openssl
