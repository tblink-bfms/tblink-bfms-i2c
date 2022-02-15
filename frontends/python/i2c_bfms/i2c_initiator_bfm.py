'''
Created on Feb 12, 2022

@author: mballance
'''
import tblink_rpc
import ctypes

@tblink_rpc.iftype("i2c_bfms.initiator")
class I2cInitiatorBfm(object):
    
    def __init__(self):
        self._ev = tblink_rpc.event()
        self._lock = tblink_rpc.lock()
        self._is_reset = False
        self._is_reset_ev = tblink_rpc.event()
        self._data = 0
        self._ack = 0
        pass
    
    async def memwrite(self, dev_a, mem_a, data):
        await self._lock.acquire()

        
        if not self._is_reset:
            await self._is_reset_ev.wait()
            self._is_reset_ev.clear()
        
        a_data = (((dev_a & 0x7F) << 1) | 0)
        await self._cmd_write(a_data, 1, 0)
        
        await self._ev.wait()
        self._ev.clear()
        
        a_data = (mem_a & 0x7F)
        await self._cmd_write(a_data, 0, 0)
        
        await self._ev.wait()
        self._ev.clear()
        
        for i, d in enumerate(data):
            if i+1 == len(data):
                stop = 1
            else:
                stop = 0;
            await self._cmd_write(d, 0, stop)
            
            await self._ev.wait()
            self._ev.clear()
            
        self._lock.release()
        
    async def memread(self, dev_a, mem_a, sz):
        await self._lock.acquire()
        
        if not self._is_reset:
            await self._is_reset_ev.wait()
            self._is_reset_ev.clear()
            
        ret = []
            
        a_data = (((dev_a & 0x7F) << 1) | 0)
        await self._cmd_write(a_data, 1, 0)
        
        await self._ev.wait()
        self._ev.clear()
        
        a_data = (mem_a & 0x7F)
        await self._cmd_write(a_data, 0, 0)
        
        await self._ev.wait()
        self._ev.clear()
        
        a_data = (((dev_a & 0x7F) << 1) | 1)
        await self._cmd_write(a_data, 1, 0)
        
        await self._ev.wait()
        self._ev.clear()
        
        for i in range(sz):
            if i+1 == sz:
                ack = 1
            else:
                ack = 0
                
            await self._cmd_read(ack, 1)
            
            await self._ev.wait()
            self._ev.clear()
            
            ret.append(self._data)
            
        self._lock.release()
            
        return ret
            
        
    
    @tblink_rpc.exptask
    def _set_prescale(self, prescale : ctypes.c_uint16):
        pass
    
    @tblink_rpc.exptask
    def _cmd_read(self, ack : ctypes.c_uint8, stop : ctypes.c_uint8):
        pass
    
    @tblink_rpc.exptask
    def _cmd_write(self, data : ctypes.c_uint8, start : ctypes.c_uint8, stop : ctypes.c_uint8):
        pass
    
    @tblink_rpc.impfunc
    def _ack_cmd(self, data : ctypes.c_uint8, ack : ctypes.c_uint8):
        self._data = data
        self._ack = ack
        self._ev.set() 
        pass
    
    @tblink_rpc.impfunc
    def _reset(self):
        self._is_reset = True
        self._is_reset_ev.set()
        
    