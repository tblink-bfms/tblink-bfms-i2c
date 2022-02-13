
import cocotb
import tblink_rpc.cocotb_compat as cocotb_compat
from i2c_bfms import I2cInitiatorBfm


@cocotb.test()
async def entry(dut):
    print("Hello")

    print("--> Await", flush=True)
    await cocotb_compat.init()
    print("<-- Await", flush=True)

    bfm = cocotb_compat.find_ifinst(".*u_bfm")

    print("--> _set_prescale", flush=True)    
    await bfm._set_prescale(100)
    print("<-- _set_prescale", flush=True)    
