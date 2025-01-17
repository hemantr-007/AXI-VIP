/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_ENV_PKG
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_ENV_PKG_SV
`define AXI_ENV_PKG_SV

package axi_env_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  
  import axi_mas_pkg::*;
  
  import axi_slv_pkg::*;
  
  `include "axi_env_config.svh"
  
  `include "axi_agent_uvc.sv"
  `include "axi_sagent_uvc.sv"
	
  `include "axi_env.sv"
  
endpackage

`endif



