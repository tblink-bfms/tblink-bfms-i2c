
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
    await bfm._set_prescale(0x100)
    print("<-- _set_prescale", flush=True)    

    for i in range(4):
        await bfm.memwrite(0x3c, i, [i+1])
    
    for i in range(4):
        data = await bfm.memread(0x3c, i, 1)
        
        if data[0] != i+1:
            print("Error: Expect %d ; receive %d" % (i+1, data[0]))
        else:
            print("Pass: ")
    
    print("data=%s" % str(data), flush=True)
