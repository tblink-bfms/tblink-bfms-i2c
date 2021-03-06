TBLINK_BFMS_I2C_VE_COMMONDIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TBLINK_BFMS_I2CDIR:=$(abspath $(TBLINK_BFMS_I2C_VE_COMMONDIR)/../..)
PACKAGES_DIR := $(TBLINK_BFMS_I2CDIR)/packages
DV_MK:=$(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
include $(DV_MK)
else # Rules
include $(DV_MK)

endif

