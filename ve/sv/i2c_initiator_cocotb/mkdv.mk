MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR:=$(dir $(MKDV_MK))
PACKAGES_DIR := $(abspath $(TEST_DIR)/../../../packages)
MKDV_TOOL ?= questa

MKDV_VL_SRCS += $(MKDV_CACHEDIR)/bfm/backends/i2c_initiator_bit_ctrl.v
MKDV_VL_SRCS += $(MKDV_CACHEDIR)/bfm/backends/i2c_initiator_byte_ctrl.v
 
ifeq (icarus,$(MKDV_TOOL))
  TBLINK_RPC_PLUGIN := $(shell python3 -m tblink_rpc_hdl simplugin vpi)
  MKDV_VL_SRCS += $(MKDV_CACHEDIR)/bfm/backends/i2c_initiator_bfm_vl.sv
  VPI_LIBS += $(TBLINK_RPC_PLUGIN)
else
  TBLINK_RPC_PLUGIN := $(shell python3 -m tblink_rpc_hdl simplugin dpi)
  TBLINK_RPC_SV_FILES := $(shell python3 -m tblink_rpc_hdl files sv)
  DPI_LIBS += $(TBLINK_RPC_PLUGIN)
  MKDV_VL_SRCS += $(TBLINK_RPC_SV_FILES)
  MKDV_VL_INCDIRS += $(sort $(dir $(TBLINK_RPC_SV_FILES)))
  MKDV_VL_SRCS += $(MKDV_CACHEDIR)/bfm/backends/i2c_initiator_bfm_sv.sv
endif

#MKDV_PLUGINS += cocotb

MKDV_PYTHONPATH += $(TEST_DIR) $(abspath $(TEST_DIR)/../../../frontends/python)
MKDV_COCOTB_MODULE = smoke_initiator

MKDV_BUILD_DEPS += gen-bfms
MKDV_VL_SRCS += $(TEST_DIR)/i2c_initiator_tb.sv
MKDV_VL_SRCS += $(TEST_DIR)/i2cSlave.v $(TEST_DIR)/registerInterface.v 
MKDV_VL_SRCS += $(TEST_DIR)/serialInterface.v
MKDV_VL_INCDIRS += $(TEST_DIR)
TOP_MODULE=i2c_initiator_tb

VLSIM_CLKSPEC += clock=10ns
VLSIM_OPTIONS += -Wno-fatal

MKDV_RUN_ARGS += +tblink.launch=python.loopback 
MKDV_RUN_ARGS += +python=$(PACKAGES_DIR)/python/bin/python
MKDV_RUN_ARGS += +module=tblink_rpc.rt.cocotb

MODULE=$(MKDV_COCOTB_MODULE)
export MODULE


include $(TEST_DIR)/../../common/defs_rules.mk

RULES := 1

include $(TEST_DIR)/../../common/defs_rules.mk

$(MKDV_CACHEDIR)/bfm/backends/rv_initiator_bfm_sv.sv : gen-bfms

.PHONY: gen-bfms
gen-bfms: 
	$(Q)$(PACKAGES_DIR)/python/bin/python3 -m tblink_bfms gen \
		-o bfm $(TBLINK_BFMS_I2CDIR)/i2c_bfms.yaml \
		$(TBLINK_BFMS_I2CDIR)/frontends \
		$(TBLINK_BFMS_I2CDIR)/backends


