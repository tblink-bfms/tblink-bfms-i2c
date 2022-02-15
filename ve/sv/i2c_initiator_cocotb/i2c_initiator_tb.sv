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
	
	reg reset = 0;
	reg[7:0] reset_cnt = 0;
	wire scl_i, scl_o, scl_en_o;
	wire sda_i, sda_o, sda_en_o;
	
	
	always @(posedge clock) begin
		if (reset_cnt == 40) begin
			reset <= 1'b0;
		end else begin
			if (reset_cnt == 1) begin
				reset <= 1'b1;
			end 
			reset_cnt <= reset_cnt + 1;
		end
	end

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

	wire targ_sda_o;
	wire targ_sda_i;
	wire targ_sda_en_o;
	wire targ_scl_i;
	wire[7:0] myReg0, myReg1, myReg2, myReg3;
	wire[7:0] myReg4, myReg5, myReg6, myReg7;
	assign myReg4 = 20;
	assign myReg5 = 21;
	assign myReg6 = 22;
	assign myReg7 = 23;
	i2cSlave u_target (
		.clk       (clock    ), 
		.rst       (reset    ), 
		.sda_o     (targ_sda_o    ), 
		.sda_i     (targ_sda_i    ), 
		.sda_en_o  (targ_sda_en_o ), 
//		.scl_o     (scl_o    ), 
		.scl_i     (targ_scl_i    ), 
//		.scl_en_o  (scl_en_o ), 
		.myReg0    (myReg0   ), 
		.myReg1    (myReg1   ), 
		.myReg2    (myReg2   ), 
		.myReg3    (myReg3   ), 
		.myReg4    (myReg4   ), 
		.myReg5    (myReg5   ), 
		.myReg6    (myReg6   ), 
		.myReg7    (myReg7   ));
	
	assign scl_i = (!scl_en_o)?scl_o:1'b1;
	assign sda_i = (!sda_en_o)?sda_o:targ_sda_o;
	
	assign targ_sda_i = (!targ_sda_en_o)?targ_sda_o:(sda_o | sda_en_o);
	assign targ_scl_i = (!scl_en_o)?scl_o:1'b1;

endmodule


