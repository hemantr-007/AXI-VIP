/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_TEST_PKG
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_TEST_PKG_SV
`define AXI_TEST_PKG_SV


package axi_test_pkg;

  import uvm_pkg::*;
  
  `include "uvm_macros.svh"
  import axi_env_pkg::*;
  import axi_mas_pkg::*;
  import axi_slv_pkg::*;
  `include "axi_base_test.sv"
  
  //sanity test
  `include "axi_sanity_seqs.sv"
  `include "axi_sanity_test.sv"
  
endpackage

`endif