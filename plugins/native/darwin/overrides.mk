# This file is part of MXE. See LICENSE.md for licensing information.

# Xcode no longer supports 32-bit compiler
# https://mxe.cc/#issue-non-multilib

override EXCLUDE_PKGS += ocaml%
$(foreach PKG,$(filter ocaml%,$(PKGS)),\
    $(foreach TGT,$(MXE_TARGETS),\
        $(eval $(PKG)_BUILD_$(TGT) :=)))
