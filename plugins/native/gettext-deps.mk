# This file is part of MXE. See LICENSE.md for licensing information.

# native build of gettext requires recent autotools
gettext_DEPS_$(BUILD) := $(gettext_DEPS_$(BUILD)) libtool
