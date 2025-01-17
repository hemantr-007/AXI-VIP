/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_INTERFACE
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SLV_INF_SV
`define AXI_SLV_INF_SV
                                                                          
`define IN_SKEW_NS 1
`define OUT_SKEW_NS 1

`include "axi_slv_define.sv"

interface axi_slv_inf (input bit ACLK); 
  
  parameter ADDR_WIDTH = 32,
			DATA_WIDTH = 32,
			SIZE = 3;
		
  logic ARESETn;
  
  //write address channel signal:- 
  logic [ADDR_WIDTH-1 : 0] AW_ADDR_q;//todo
  logic [SIZE : 0] AW_ID;
  logic [SIZE : 0] AW_LEN;
  logic [SIZE - 2 : 0]AW_BURST;
  logic [SIZE-1 : 0]AW_SIZE;
  logic AWVALID;
  logic AWREADY;
  
  //write data channel signal :- 
  logic [(DATA_WIDTH - 1) : 0]W_DATA;
  logic [ SIZE : 0]W_STRB;
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
  logic [(SIZE - 2) : 0]R_RESP;
  logic [(DATA_WIDTH - 1) : 0]R_DATA;
  logic R_LAST;
  logic RVALID;
  logic RREADY;
  
/*The source generates the VALID signal to indicate when the data or control information is 
available. The destination generates the READY signal to indicate that it accepts the 
data or control information. Transfer occurs only when both the VALID and READY
signals are HIGH.*/  
  
  //slave driver clocking block//  
  clocking slv_drv_cb @(posedge ACLK);
  
	  default input #`IN_SKEW_NS output #`OUT_SKEW_NS;
      
	  input AW_ADDR_q,AW_ID,AW_LEN,AW_BURST,AW_SIZE,
			 AWVALID,W_DATA,W_STRB,W_LAST,W_ID,WVALID; 
	
	  input AR_ID,AR_VALID,BREADY,RREADY,
			 AR_LEN,AR_ADDR_q,AR_BURST,AR_SIZE;
	  
	  output AR_READY,WREADY,AWREADY,
			RVALID,R_LAST,R_RESP,R_ID,R_DATA;
	  
	  output B_ID,B_RESP,BVALID;
 
  endclocking 
  
  //slave monitor clocking block//
  clocking slv_mon_cb @(posedge ACLK);
	  
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

  modport SLV_DRV_MP (input ARESETn,
                      clocking slv_drv_cb);
  
  modport SLV_MON_MP (input ARESETn,
                      clocking slv_mon_cb);

 
				  
endinterface 

`endif

