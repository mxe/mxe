# This file is part of MXE.
# See index.html for further information.

GIT_DIR = $(if $(patsubst .,,$($(1)_SUBDIR)) \
    ,$(GITS_DIR)/$($(1)_SUBDIR),$(GITS_DIR)/$(1))

GIT_CMD = git \
    --work-tree='$(call GIT_DIR,$(1))' \
    --git-dir='$(call GIT_DIR,$(1))'/.git

PATCH_NAME = 1-fixes

# can't use PKG_PATCHES here, because it returns existing patches
# while export-patch creates new patch
PATCH_BY_NAME = $(patsubst %.mk,%-$(2).patch,$(PKG_MAKEFILES))

define INIT_GIT
    # unpack to gits/tmp/pkg
    rm -rf '$(GITS_DIR)/tmp'
    mkdir -p '$(GITS_DIR)/tmp/$(1)'
    cd '$(GITS_DIR)/tmp/$(1)' && $(call UNPACK_PKG_ARCHIVE,$(1))
    # if PKG_SUBDIR is ".", the following will move gits/tmp/pkg
    mv '$(abspath $(GITS_DIR)/tmp/$(1)/$($(1)_SUBDIR))' '$(call GIT_DIR,$(1))'
    rm -rf '$(GITS_DIR)/tmp'
    # initialize git
    $(call GIT_CMD,$(1)) init
    $(call GIT_CMD,$(1)) add -A
    $(call GIT_CMD,$(1)) commit -m "init"
    $(call GIT_CMD,$(1)) tag dist
endef

define IMPORT_PATCH
    cd '$(call GIT_DIR,$(1))' \
        && cat '$(2)' \
        | sed '/^From/,$$  !d' \
        | sed s/'^From: MXE'/"From: fix@me"/'g;' \
        | $(call GIT_CMD,$(1)) am --keep-cr ;
endef

define EXPORT_PATCH
    cd '$(call GIT_DIR,$(1))' \
    && ( \
        echo 'This file is part of MXE.'; \
        echo 'See index.html for further information.'; \
        echo ''; \
        echo 'Contains ad hoc patches for cross building.'; \
        echo ''; \
        $(call GIT_CMD,$(1)) format-patch \
            --no-numbered \
            -p \
            --no-signature \
            --stdout \
            --text \
            -M9 \
            dist..HEAD \
        | sed 's/^From [0-9a-f]\{40\} /From 0000000000000000000000000000000000000000 /' \
        | sed 's/^index .......\.\......../index 1111111..2222222/' \
    ) > '$(PATCH_BY_NAME)'
endef

init-git-%: download-only-%
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(if $(wildcard $(call GIT_DIR,$*)), \
	        $(error $(call GIT_DIR,$*) already exists), \
	        $(call INIT_GIT,$*)), \
	    $(error Package $* not found in index.html))

import-patch-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(if $(wildcard $(call GIT_DIR,$*)), \
	        $(call IMPORT_PATCH,$*,$(call PATCH_BY_NAME,$*,$(PATCH_NAME))), \
	        $(error $(call GIT_DIR,$*) does not exist)), \
	    $(error Package $* not found in index.html))

import-all-patches-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(if $(wildcard $(call GIT_DIR,$*)), \
	        $(foreach PKG_PATCH,$(call PKG_PATCHES,$*), \
	            $(call IMPORT_PATCH,$*,$(PKG_PATCH))), \
	        $(error $(call GIT_DIR,$*) does not exist)), \
	    $(error Package $* not found in index.html))

export-patch-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(if $(wildcard $(call GIT_DIR,$*)), \
	        $(call EXPORT_PATCH,$*,$(PATCH_NAME)), \
	        $(error $(call GIT_DIR,$*) does not exist)), \
	    $(error Package $* not found in index.html))
