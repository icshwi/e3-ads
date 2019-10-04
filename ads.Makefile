#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Friday, March 29 00:01:17 CET 2019
# version : 0.0.3
#
## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS



# If one would like to use the module dependency restrictly,
# one should look at other modules makefile to add more
# In most case, one should ignore the following lines:

ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif


## Exclude linux-ppc64e6500
EXCLUDE_ARCHS = linux-ppc64e6500
#EXCLUDE_ARCHS += linux-corei7-poky

APP:=adsApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

CXXFLAGS += -std=c++11

USR_INCLUDES += -I$(where_am_I)$(APPSRC)
USR_INCLUDES += -I$(where_am_I)../$(ADS_SRC_PATH)/AdsLib

# USR_CFLAGS   += -Wno-unused-variable
# USR_CFLAGS   += -Wno-unused-function
# USR_CFLAGS   += -Wno-unused-but-set-variable
# USR_CPPFLAGS += -Wno-unused-variable
# USR_CPPFLAGS += -Wno-unused-function
# USR_CPPFLAGS += -Wno-unused-but-set-variable

TEMPLATES += $(wildcard $(APPDB)/*.db)
TEMPLATES += $(wildcard $(APPDB)/*.proto)
TEMPLATES += $(wildcard $(APPDB)/*.template)


HEADERS += $(APPSRC)/adsAsynPortDriver.h
HEADERS += $(APPSRC)/adsAsynPortDriverUtils.h
# HEADERS += $(DBDINC_HDRS)


SOURCES += $(APPSRC)/adsAsynPortDriver.cpp
SOURCES += $(APPSRC)/adsAsynPortDriverUtils.cpp
DBDS    += $(APPSRC)/ads.dbd

#
ADS_LIB = ADS
#
ifeq ($(T_A),linux-x86_64)
USR_LDFLAGS += -Wl,--enable-new-dtags
USR_LDFLAGS += -Wl,-rpath=$(E3_MODULES_VENDOR_LIBS_LOCATION)
USR_LDFLAGS += -L$(E3_MODULES_VENDOR_LIBS_LOCATION)
LIB_SYS_LIBS += $(ADS_LIB)
endif

VENDOR_LIBS += ../ADS/lib$(ADS_LIB).so.$(ADS_MODULE_VERSION)



SCRIPTS += $(wildcard ../iocsh/*.iocsh)


## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

db: 
	echo $(VENDOR_LIBS)

.PHONY: db 

#
USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)
#
SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)
#
db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@

#
.PHONY: db $(SUBS) $(TMPS)

vlibs: $(VENDOR_LIBS)

$(VENDOR_LIBS): 
	$(QUIET)$(SUDO) install -m 755 -d $(E3_MODULES_VENDOR_LIBS_LOCATION)/
	$(QUIET)$(SUDO) install -m 755 $@ $(E3_MODULES_VENDOR_LIBS_LOCATION)/
	$(foreach lib, $(notdir $@), $(QUIET)$(SUDO) ln -sf $(E3_MODULES_VENDOR_LIBS_LOCATION)/$(lib) $(E3_MODULES_VENDOR_LIBS_LOCATION)/$(lib:.$(ADS_MODULE_VERSION)=))

.PHONY: $(VENDOR_LIBS) vlibs



