# This file is part of MXE. See LICENSE.md for licensing information.

$(info == Custom Qt overrides: $(lastword $(MAKEFILE_LIST)))

# reduced qt5
qtbase_DEPS := $(filter-out libmysqlclient postgresql freetds,$(qtbase_DEPS))
qtbase_BUILD_SHARED = $(subst -plugin-sql-mysql, -no-sql-mysql, \
					  $(subst -plugin-sql-psql, -no-sql-psql, \
					  $(subst -plugin-sql-tds, -no-sql-tds, \
					  $(subst -static, -shared, $(qtbase_BUILD)) )))
