/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_MONITOR
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_BASE_TEST_SV
`define AXI_BASE_TEST_SV

class axi_base_test extends uvm_test;
	
	//-------factory registration
	`uvm_component_utils(axi_base_test)
	
	//------- AHB ENVIRONMENT
	axi_env env_h;
	
	//-------constructor 
	function new(string name = "", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
	function void end_of_elaboration_phase (uvm_phase phase);
	   uvm_top.print_topology();
	endfunction
	
	//////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void build_phase (uvm_phase phase);
	  env_h=axi_env::type_id::create("env_h",this);
   endfunction 
	
endclass : axi_base_test

`endif 