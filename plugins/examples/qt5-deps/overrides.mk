# This file is part of MXE.
# See index.html for further information.

poppler_DEPS := $(filter-out qt ,$(poppler_DEPS)) qtbase
openscenegraph_DEPS := $(filter-out qt ,$(openscenegraph_DEPS)) qtbase
