/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_UVC
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_AGENT_UVC_SV
`define AXI_AGENT_UVC_SV

class axi_agent_uvc extends uvm_agent;
	
	//-------factory registration
	`uvm_component_utils(axi_agent_uvc)
	
	//-------component handle 
	axi_mas_config mas_config_h[];
	//axi_mas_config mas_config_h2;
	
	axi_env_config env_config;
	
	axi_mas_agent #(32,32,3) mas_agnt_h[];
	//axi_mas_agent #(32,32,3) mas_agnt_h2;
	
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
		super.build_phase(phase);
		
	    //get environment configuration +++++
	    if (!uvm_config_db #(axi_env_config)::get(this,"","env_config",env_config))
	      `uvm_fatal("ENV_CONFIG_GET","ENV config is not available")
	    
		mas_config_h = new[env_config.no_of_agent];
		mas_agnt_h = new[env_config.no_of_agent];
		foreach(mas_config_h[i]) begin
		  mas_config_h[i] = axi_mas_config::type_id::create($sformatf("mas_config_h[%0d]",i));
		  case(i)
 		   'h0 : begin
		           mas_config_h[i].is_active = UVM_ACTIVE;
				   mas_agnt_h[i] = axi_mas_agent #(32,32,3)::type_id::create($sformatf("mas_agnt_h[%0d]",i),this); 
		           uvm_config_db #(axi_mas_config)::set(this,"mas_agnt_h[0]*","mas_config",mas_config_h[0]);
				 end
		   'h1 : begin
		           mas_config_h[i].is_active = UVM_PASSIVE;
				   mas_agnt_h[i] = axi_mas_agent #(32,32,3)::type_id::create($sformatf("mas_agnt_h[%0d]",i),this); 
		           uvm_config_db #(axi_mas_config)::set(this,"mas_agnt_h[1]*","mas_config",mas_config_h[1]);
				 end
		  endcase
		  
		  mas_agnt_h[i].set_index(i);
		  
		   uvm_config_db #(axi_mas_config)::set(this,$sformatf("mas_agnt_h[i]",i),"mas_config",mas_config_h[i]);
		end //foreach
	/*
		mas_config_h2 = axi_mas_config::type_id::create("mas_config_h2");
		mas_config_h2.is_active = UVM_ACTIVE;
		mas_agnt_h2 = axi_mas_agent #(32,32,3)::type_id::create("mas_agnt_h2",this); 
		mas_agnt_h2.set_index(1);		
		uvm_config_db #(axi_mas_config)::set(this,"mas_agnt_h2","mas_config",mas_config_h2);
		*/
	endfunction 
	
endclass 

`endif 
	
	
	

	
	
	