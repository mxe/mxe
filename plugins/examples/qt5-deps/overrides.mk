# This file is part of MXE. See LICENSE.md for licensing information.

poppler_DEPS := $(filter-out qt ,$(poppler_DEPS)) qtbase
openscenegraph_DEPS := $(filter-out qt ,$(openscenegraph_DEPS)) qtbase
