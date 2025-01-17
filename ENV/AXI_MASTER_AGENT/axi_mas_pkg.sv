/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_PACKAGE
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_PKG_SV
`define AXI_MAS_PKG_SV

`include "axi_mas_inf.sv"

package axi_mas_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  
  `include "axi_mas_define.sv"
  `include "axi_mas_config.svh"
  
  `include "axi_mas_seq_item.sv"
  `include "axi_mas_driver.sv"
  
  `include "axi_mas_seqr.sv"
  `include "axi_mas_monitor.sv"
  
  `include "axi_mas_agent.sv"
  `include "axi_mas_base_seq.sv"
  
endpackage

`endif



