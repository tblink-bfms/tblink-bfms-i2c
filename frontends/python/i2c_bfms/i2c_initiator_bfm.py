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
    
    async def write(self, addr, data):
        await self._lock.acquire()

        
        if not self._is_reset:
            await self._is_reset_ev.wait()
            self._is_reset_ev.clear()
        
        a_data = ((addr & 0x7F) << 1)
        await self._cmd_write(a_data, 1)
        
        await self._ev.wait()
        self._ev.clear()
        
        for d in data:
            await self._cmd_write(d, 0)
            
            await self._ev.wait()
            self._ev.clear()
            
        await self._cmd_stop()
        await self._ev.wait()
        self._ev.clear()
        
        self._lock.release()
        
    async def read(self, addr, sz):
        await self._lock.acquire()
        
        if not self._is_reset:
            await self._is_reset_ev.wait()
            self._is_reset_ev.clear()
            
        ret = []
            
        a_data = ((addr & 0x7F) << 1)
        await self._cmd_write(a_data, 1)
        
        await self._ev.wait()
        self._ev.clear()
        
        for _ in range(sz):
            await self._cmd_read()
            
            await self._ev.wait()
            self._ev.clear()
            
            ret.append(self._data)
            
        await self._cmd_stop()
        await self._ev.wait()
        self._ev.clear()
        
        self._lock.release()
            
        return ret
            
        
    
    @tblink_rpc.exptask
    def _set_prescale(self, prescale : ctypes.c_uint16):
        pass
    
    @tblink_rpc.exptask
    def _cmd_start(self):
        pass
    
    @tblink_rpc.exptask
    def _cmd_stop(self):
        pass
    
    @tblink_rpc.exptask
    def _cmd_read(self):
        pass
    
    @tblink_rpc.exptask
    def _cmd_write(self, data : ctypes.c_uint8, start : ctypes.c_uint8):
        pass
    
    @tblink_rpc.impfunc
    def _ack_cmd(self, data : ctypes.c_uint8, ack : ctypes.c_uint8):
        self._ev.set() 
        self._data = data
        self._ack = ack
        pass
    
    @tblink_rpc.impfunc
    def _reset(self):
        print("_reset", flush=True)
        self._is_reset = True
        self._is_reset_ev.set()
        
    