# This file is part of MXE. See LICENSE.md for licensing information.

# Xcode no longer supports 32-bit compiler
# https://mxe.cc/#issue-non-multilib

override EXCLUDE_PKGS += ocaml%
$(foreach PKG,$(filter ocaml%,$(PKGS)),\
    $(foreach TGT,$(MXE_TARGETS),\
        $(eval $(PKG)_BUILD_$(TGT) :=)))

# silence "install JDK" popups
# move the rule to main Makefile if other systems abandon java
# and conditionally include the dependency
check-requirements: disable-native-jre

.PHONY: disable-native-jre
disable-native-jre:
	@mkdir -p '$(PREFIX)/$(BUILD)/bin'
	@( \
	 echo '#!/bin/sh'; \
	 echo 'exit 1'; \
	) > '$(PREFIX)/$(BUILD)/bin/java'
	@chmod 0755 '$(PREFIX)/$(BUILD)/bin/java'
	@cp '$(PREFIX)/$(BUILD)/bin/java' '$(PREFIX)/$(BUILD)/bin/javac'
