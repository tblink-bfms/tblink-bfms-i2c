/****************************************************************************
 * i2c_initiator_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
`timescale 1ns/1ns
`endif

  
/**
 * Module: i2c_initiator_tb
 * 
 * TODO: Add module documentation
 */
module i2c_initiator_tb(input clock);
	
`ifdef IVERILOG
`include "iverilog_control.svh"
`endif
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	assign clock = clock_r;
`endif
	
	wire reset = 0;
	wire scl_i, scl_o, scl_en_o;
	wire sda_i, sda_o, sda_en_o;

	i2c_initiator_bfm_sim u_bfm (
			.clock(	clock),
			.reset(	reset),
			.scl_i(	scl_i),
			.scl_o(	scl_o),
			.scl_en_o(scl_en_o),
			.sda_i(	sda_i),
			.sda_o(	sda_o),
			.sda_en_o(sda_en_o)
			);	

endmodule


