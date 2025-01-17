/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_PACKAGE
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SLV_PKG_SV
`define AXI_SLV_PKG_SV

`include "axi_slv_inf.sv"

package axi_slv_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  
  `include "axi_slv_define.sv"
  `include "axi_slv_config.svh"
  
  `include "axi_slv_seq_item.sv"
  `include "axi_slv_driver.sv"
  
  `include "axi_slv_seqr.sv"
  `include "axi_slv_monitor.sv"

  `include "axi_slv_agent.sv"
  `include "axi_slv_base_seq.sv"
  
endpackage

`endif



