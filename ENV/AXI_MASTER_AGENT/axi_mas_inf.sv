/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_INTERFACE
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_INF_SV
`define AXI_MAS_INF_SV
                                                                          
`define IN_SKEW_NS 1
`define OUT_SKEW_NS 1

`include "axi_mas_define.sv"

interface axi_mas_inf (input bit ACLK); 
  
  parameter ADDR_WIDTH = 32,
			DATA_WIDTH = 32,
			SIZE = 3;
		
  logic ARESETn;
  
  //write address channel signal:- 
  logic [ADDR_WIDTH-1 : 0] AW_ADDR_q;
  logic [SIZE : 0] AW_ID;
  logic [SIZE : 0] AW_LEN;
  logic [SIZE - 2 : 0]AW_BURST;
  logic [SIZE-1 : 0]AW_SIZE;
  logic AWVALID;
  logic AWREADY;
  
  //write data channel signal :- 
  logic [(DATA_WIDTH - 1) : 0]W_DATA;
  logic [SIZE : 0]W_STRB;
  logic W_LAST;
  logic [SIZE : 0]W_ID;
  logic WVALID;
  logic WREADY; 	
  
  //Write response channel signal:-
  logic [SIZE : 0]B_ID;
  logic [(SIZE - 2) : 0 ]B_RESP;
  logic BREADY;
  logic BVALID;
  
  //read address channel signal:-
  logic [ADDR_WIDTH-1 : 0]AR_ADDR_q;
  logic [SIZE : 0]AR_ID;
  logic [SIZE - 2 : 0]AR_BURST;
  logic [SIZE : 0]AR_LEN;
  logic [SIZE -1 : 0]AR_SIZE;
  logic AR_VALID;
  logic AR_READY;
  
  //read data channel signal :- 
  logic [SIZE : 0]R_ID;
  logic [SIZE - 2 : 0]R_RESP;
  logic [DATA_WIDTH - 1 : 0]R_DATA;
  logic R_LAST;
  logic RVALID;
  logic RREADY;
  
/*The source generates the VALID signal to indicate when the data or control information is 
available. The destination generates the READY signal to indicate that it accepts the 
data or control information. Transfer occurs only when both the VALID and READY
signals are HIGH.*/  
  
  //Master driver clocking block//  
  clocking mas_drv_cb @(posedge ACLK);
  
	  default input #`IN_SKEW_NS output #`OUT_SKEW_NS;
      
	  output AW_ADDR_q,AW_ID,AW_LEN,AW_BURST,AW_SIZE,
			 AWVALID,W_DATA,W_STRB,W_LAST,W_ID,WVALID; 
	
	  output AR_ID,AR_VALID,BREADY,RREADY,
			 AR_LEN,AR_ADDR_q,AR_BURST,AR_SIZE;
	  
	  input AR_READY,WREADY,AWREADY,
			RVALID,R_LAST,R_RESP,R_ID,R_DATA;
	  
	  input B_ID,B_RESP,BVALID;
 
  endclocking 
  
  //Master monitor clocking block//
  clocking mas_mon_cb @(posedge ACLK);
	  
	  default input #`IN_SKEW_NS output #`OUT_SKEW_NS;
	  
	  input AW_ADDR_q,AW_ID,AW_LEN,AW_BURST,AW_SIZE,
			 AWVALID,W_DATA,W_STRB,W_LAST,W_ID,WVALID; 
	
	  input  AR_ID,BREADY,AR_VALID,
			 AR_LEN,AR_ADDR_q,AR_BURST,AR_SIZE;
	  
	  input B_ID,B_RESP,BVALID,AR_READY,
			RVALID,R_LAST,R_RESP,R_ID,R_DATA;
	  
	  input AWREADY,RREADY,
			 WREADY;
	  
  endclocking

  modport MAS_DRV_MP (input ARESETn,
                      clocking mas_drv_cb);
  
  modport MAS_MON_MP (input ARESETn,
                      clocking mas_mon_cb);
/*					  
//=============================ASSERTION===========================================//

//WRITE_ADDRESS CHANNEL==============================================================
property WRITE_ADDRESS_CHECKER(signal);
	disable iff (ARESETn)
	@(posedge ACLK)
	$rose(AWVALID) && $rose(AWREADY) |-> !$isunknown(signal); // this signal check for AWVALID & AWREADY high then address is not required unknown
endproperty

AW_ADDR_CHECK : assert property (WRITE_ADDRESS_CHECKER(AW_ADDR))
				else 
					$error($time,"AW_ADDRESS IS UNKNOWN at %0t");
					
//if AW_VALID AND AW_READY  detect high then AW_ADDRESS Transfer occurs....!!!

//WRITE_DATA_CHANNEL================================================================
property DATA_CHECKER(signal);
    disable iff (ARESETn)
	@(posedge ACLK)
	$rose(WVALID) && $rose(WREADY) |-> !$isunknown(signal); // this signal check for WVALID & WREADY high then data is not required unknown
endproperty

W_DATA_CHECK : assert property (DATA_CHECKER(W_DATA))
				else 
					$error($time,"W_DATA IS UNKNOWN at %0t");

//if W_VALID AND W_READY  detect high then W_DATA Transfer occurs....!!!

//READ_ADDRESS CHANNEL==============================================================
property READ_ADDRESS_CHECKER(signal);
	disable iff (ARESETn)
	@(posedge ACLK)
	$rose(AR_VALID) && $rose(AR_READY) |-> !$isunknown(signal); // this signal check for ARVALID & ARREADY high then address is not required unknown
endproperty

AR_ADDR_CHECK : assert property (READ_ADDRESS_CHECKER(AR_ADDR))
				else 
					$error($time,"AR_ADDRESS IS UNKNOWN at %0t");

//if AR_VALID AND AR_READY  detect high then AR_ADDRESS Transfer occurs....!!!
					
//READ_DATA_CHANNEL==================================================================
property READ_DATA_CHECKER(signal);
    disable iff (ARESETn)
	@(posedge ACLK)
	$rose(RVALID) && $rose(RREADY) |-> !$isunknown(signal); // this signal check for RVALID & RREADY high then data is not required unknown
endproperty

R_DATA_CHECK : assert property (READ_DATA_CHECKER(R_DATA))
				else 
					$error($time,"R_DATA IS UNKNOWN at %0t");

//if R_VALID AND R_READY  detect high then R_DATA Transfer occurs....!!!

//W_LAST && R_LAST CHECKER===========================================================				
sequence w_last_seq1;
	@(posedge ACLK)
	(W_DATA == AW_LEN - 1) |-> (W_LAST); 
endsequence 

sequence r_last_seq1;
	@(posedge ACLK);
	(R_DATA = AR_LEN - 1) |-> (R_LAST);
endsequence

property LAST_DATA_CHECKER;
	@(posedge ACLK);
	!($isunknown(W_DATA) && $isunknown(R_DATA)) |-> w_last_seq1 ## 0 r_last_seq1; 
endproperty

LAST_CHECKER : assert property (LAST_DATA_CHECKER) 
			   else 
					$error($time,"W_LAST is failed at %0t");

//last apperence of W_DATA && R_DATA occurs then for both W_LAST && R_LAST state should be changed...!!!

//VALID--READY TRANSACTIONS============================================================

sequence wr_valid_ready_seq;
	@(posedge ACLK);
	$rose(AWREADY) |-> ($past(AW_VALID and W_VALID,1) == 1'b1);
	$rose(W_READY) |-> ($past (AW_VALID and W_VALID,1) == 1'b1);
endsequence

sequence response_seq;
	$rose(BVALID) |-> ($past(W_VALID and W_READY,1) == 1'b1);
	$rose(BREADY) |-> ($past(BVALID,1) == 1'b1);
endsequence

sequence rd_valid_ready_seq;
	$rose(AR_READY) |-> ($past (AR_VALID,1) == 1'b1);
	$rose(RVALID) |-> ($past(AR_VALID and AR_READY,1) == 1'b1); 
endsequence
	
property VALID_READY_CHECKER;
	@(posedge ALCK);
	wr_valid_ready_seq |=> response_seq |=> rd_valid_ready_seq;
endproperty

VALID_READY: assert property (VALID_READY_CHECKER)
			 else 
				$error($time,"valid and ready are failed at %0t");

//ADDRESS_DATA_CHECKER================================================================

property WR_RD_ADDR_DATA_CHECK;
	@(posedge ACLK);
	$rose(AW_ADDR) |-> ##[1:2] W_DATA;
	$rose(AR_ADDR)|-> ##[1:2] R_DATA;
endproperty

ADDR_DATA_CHECKER: assert property (WR_RD_ADDR_DATA_CHECK)
			 else 
				$error($time,"Not specified addr and data at time  %0t");
				
//DATA_TRANSFER_NOT_OCCUR
sequence addr_channel_seq;
		@(posedge ACLK);

endsequence

property WR_RD_ADDR_DATA_CHECK;
	@(posedge ACLK);
	$fell(AWVALID and AWREADY) |-> $isunknown(AW_ADDR);
	$fell(WVALID and WREADY) |-> $isunknown(W_DATA);
	$fell(AR_VALID and AR_READY) |-> $isunknown(AR_ADDR);
	$fell(RVALID and RREADY) |-> $isunknown(R_DATA);
endproperty

ADDR_DATA_CHECKER: assert property (WR_RD_ADDR_DATA_CHECK)
			 else 
				$error($time,"Not specified addr and data at time  %0t");
*/				
endinterface 

`endif

