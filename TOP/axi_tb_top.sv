/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_TOP_MODULE
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

module axi_tb_top();
`include "uvm_macros.svh"

 import uvm_pkg::*;

 import axi_test_pkg::*;

 bit clk;
 
 always #5 clk = ~clk;
 
 //insterface instance
 axi_mas_inf #(32,32,3) axi_mas_vif_0(clk);
 
 axi_mas_inf #(32,32,3) axi_mas_vif_1(clk);
 
 axi_slv_inf #(32,32,3) axi_slv_vif_0(clk);
 
 axi_slv_inf #(32,32,3) axi_slv_vif_1(clk);
 
 // for assign signal always set the source signal to left side and destination signal to right side 
 //because data transfer from left to right.
 
 assign axi_slv_vif_0.AW_ID    = axi_mas_vif_0.AW_ID;
 assign axi_slv_vif_0.AW_LEN   = axi_mas_vif_0.AW_LEN;
 assign axi_slv_vif_0.AW_BURST = axi_mas_vif_0.AW_BURST;
 assign axi_slv_vif_0.AW_SIZE  = axi_mas_vif_0.AW_SIZE;
 assign axi_slv_vif_0.AW_ADDR_q  = axi_mas_vif_0.AW_ADDR_q;
 assign axi_slv_vif_0.AWVALID  = axi_mas_vif_0.AWVALID;
 assign axi_mas_vif_0.AWREADY  = axi_slv_vif_0.AWREADY;
 
 assign axi_slv_vif_0.W_ID   = axi_mas_vif_0.W_ID;
 assign axi_slv_vif_0.W_DATA = axi_mas_vif_0.W_DATA;
 assign axi_slv_vif_0.W_STRB = axi_mas_vif_0.W_STRB;
 assign axi_slv_vif_0.W_LAST = axi_mas_vif_0.W_LAST;
 assign axi_slv_vif_0.WVALID = axi_mas_vif_0.WVALID;
 assign axi_mas_vif_0.WREADY = axi_slv_vif_0.WREADY;
 
 assign axi_mas_vif_0.B_ID   = axi_slv_vif_0.B_ID;
 assign axi_mas_vif_0.B_RESP = axi_slv_vif_0.B_RESP;
 assign axi_mas_vif_0.BVALID = axi_slv_vif_0.BVALID;
 assign axi_slv_vif_0.BREADY = axi_mas_vif_0.BREADY;
 
 assign axi_slv_vif_0.AR_ID    = axi_mas_vif_0.AR_ID;
 assign axi_slv_vif_0.AR_LEN   = axi_mas_vif_0.AR_LEN;
 assign axi_slv_vif_0.AR_BURST = axi_mas_vif_0.AR_BURST;
 assign axi_slv_vif_0.AR_SIZE  = axi_mas_vif_0.AR_SIZE;
 assign axi_slv_vif_0.AR_ADDR_q	 = axi_mas_vif_0.AR_ADDR_q;
 assign axi_slv_vif_0.AR_VALID = axi_mas_vif_0.AR_VALID;
 assign axi_mas_vif_0.AR_READY = axi_slv_vif_0.AR_READY;
 
 assign axi_mas_vif_0.R_RESP = axi_slv_vif_0.R_RESP;
 assign axi_mas_vif_0.R_DATA = axi_slv_vif_0.R_DATA;
 assign axi_mas_vif_0.R_LAST = axi_slv_vif_0.R_LAST;
 assign axi_mas_vif_0.R_ID   = axi_slv_vif_0.R_ID;
 assign axi_mas_vif_0.RVALID = axi_slv_vif_0.RVALID;
 assign axi_slv_vif_0.RREADY = axi_mas_vif_0.RREADY;

 initial begin
	axi_mas_vif_0.ARESETn = 0;
	@(posedge clk);
	axi_mas_vif_0.ARESETn = 1;
 end
 
 initial begin
	//uvm_config_db #(int)::set(null,"uvm_test_top.env_h.slv_uvc.slv_agnt_h[0]","A",5);
	uvm_config_db #(virtual axi_mas_inf  #(32,32,3))::set(null,"uvm_test_top.env_h.mas_uvc.*","axi_mas_vif",axi_mas_vif_0);
	// uvm_config_db #(virtual axi_mas_inf  #(32,32,3))::set(null,"uvm_test_top.env_h.mas_uvc.mas_agnt_h[1]","axi_mas_vif",axi_mas_vif_1);
    uvm_config_db #(virtual axi_slv_inf  #(32,32,3))::set(null,"uvm_test_top.env_h.slv_uvc.*","axi_slv_vif",axi_slv_vif_0); 
    // uvm_config_db #(virtual axi_slv_inf  #(32,32,3))::set(null,"uvm_test_top.env_h.slv_uvc.slv_agnt_h[1]","axi_slv_vif",axi_slv_vif_1);
	run_test();
 end
 
 endmodule