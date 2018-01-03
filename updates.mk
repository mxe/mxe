# This file is part of MXE. See LICENSE.md for licensing information.

# Generic updater
# $(call GET_LATEST_VERSION, base url[, prefix, ext, filter, separator])
#  base url : required page returning list of versions
#               e.g https://ftp.gnu.org/gnu/libfoo
#  prefix   : segment before version
#               defaults to lastword of url with dash i.e. `libfoo-`
#  ext      : segment ending version - default `\.tar`
#  filter   : `grep -i` filter-out pattern - default alpha\|beta\|rc
#  separator: transform char to `.` - typically `_`
#
# test changes with:
# make check-get-latest-version
#
# and update tools/skeleton.py with usage notes

define GET_LATEST_VERSION
    $(WGET) -q -O- '$(strip $(1))' | \
    $(SED) -n 's,.*<a href=".*$(strip $(or $(2),$(lastword $(subst /,$(space),$(1)))-))\([0-9][^"]*\)$(strip $(or $(3),\.tar)).*,\1,p' | \
    grep -vi '$(strip $(or $(4),alpha\|beta\|rc))' | \
    tr '$(strip $(5))' '.' | \
    $(SORT) -V | \
    tail -1
endef

ALL_DIRS := $(MXE_PLUGIN_DIRS) $(shell find $(realpath $(TOP_DIR)/plugins) -type d)
GET_LATEST_VERSION_PKGS := $(sort \
    $(basename $(notdir $(shell grep -l GET_LATEST_VERSION -r $(ALL_DIRS)))))

.PHONY: check-get-latest-version
check-get-latest-version:
	@$(MAKE) -f '$(MAKEFILE)' \
	    $(addprefix check-update-package-,$(GET_LATEST_VERSION_PKGS)) \
	    MXE_PLUGIN_DIRS='$(ALL_DIRS)'

COMPARE_VERSIONS = $(strip \
    $(if $($(1)_BRANCH),$(call seq,$($(1)_VERSION),$(2)),\
    $(filter $(2),$(shell printf '$($(1)_VERSION)\n$(2)' | $(SORT) -V | head -1))))

.PHONY: update
define UPDATE
    $(if $(2),
        $(if $(filter $($(1)_IGNORE),$(2)),
            $(info IGNORED  $(1)  $(2)),
            $(if $(COMPARE_VERSIONS),
                $(if $(filter $(2),$($(1)_VERSION)),
                    $(info .        $(1)  $(2)),
                    $(info OLD      $(1)  $($(1)_VERSION) --> $(2) ignoring)),
                $(info NEW      $(1)  $($(1)_VERSION) --> $(2))
                $(if $(findstring undefined, $(origin UPDATE_DRYRUN)),
                    $(SED) -i 's/^\([^ ]*_VERSION *:=\).*/\1 $(2)/' '$($(1)_MAKEFILE)'
                    $(MAKE) -f '$(MAKEFILE)' 'update-checksum-$(1)' \
                        || { $(SED) -i 's/^\([^ ]*_VERSION *:=\).*/\1 $($(1)_VERSION)/' '$($(1)_MAKEFILE)'; \
                             exit 1; }))),
        $(info Unable to update version number of package $(1) \
            $(newline)$(newline)$($(1)_UPDATE)$(newline)))

endef
update:
	$(foreach PKG,$(PKGS),\
	    $(and $($(PKG)_UPDATE),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE)))))

update-package-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(and $($*_UPDATE),$(call UPDATE,$*,$(shell $($*_UPDATE)))), \
	    $(error Package $* not found))
	    @echo -n

check-update-package-%: UPDATE_DRYRUN = true
check-update-package-%: update-package-% ;

update-checksum-%: MXE_NO_BACKUP_DL = true
update-checksum-%: SKIP_CHECHSUM = true
update-checksum-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(call DOWNLOAD_PKG_ARCHIVE,$*) && \
	    $(SED) -i 's/^\([^ ]*_CHECKSUM *:=\).*/\1 '"`$(call PKG_CHECKSUM,$*)`"'/' '$($*_MAKEFILE)', \
	    $(error Package $* not found))
