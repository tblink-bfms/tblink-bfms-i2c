'''
Created on Feb 12, 2022

@author: mballance
'''
import tblink_rpc
import ctypes

@tblink_rpc.iftype("i2c_bfms.initiator")
class I2cInitiatorBfm(object):
    
    def __init__(self):
        pass
    
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
    def _cmd_write(self, data : ctypes.c_uint8):
        pass
    
    @tblink_rpc.impfunc
    def _ack_cmd(self, data : ctypes.c_uint8, ack : ctypes.c_uint8):
        pass
    