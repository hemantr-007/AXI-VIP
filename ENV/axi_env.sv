/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_ENV 
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_ENV_SV
`define AXI_ENV_SV

class axi_env extends uvm_env;
	
	//-------factory registration
	`uvm_component_utils(axi_env)
	
	// ------  ENV CONFIG
	axi_env_config env_config;
	
	//------- AXI Master UVC
	axi_agent_uvc mas_uvc;
	axi_sagent_uvc slv_uvc;
		
	//-------constructor 
	function new(string name = "", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
	//////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void build_phase (uvm_phase phase);
		
	  env_config=axi_env_config::type_id::create("env_config");
	  
	  uvm_config_db #(axi_env_config)::set(this,"*","env_config",env_config);
	   
	  mas_uvc = axi_agent_uvc::type_id::create("mas_uvc",this);
	  slv_uvc = axi_sagent_uvc::type_id::create("slv_uvc",this);
	  
   endfunction 
	
endclass : axi_env

`endif 
	
	
	

	
	
	