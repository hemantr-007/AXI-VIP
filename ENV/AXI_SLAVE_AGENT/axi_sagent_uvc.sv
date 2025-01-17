/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_UVC
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SAGENT_UVC_SV
`define AXI_SAGENT_UVC_SV

class axi_sagent_uvc extends uvm_agent;
	
	//-------factory registration
	`uvm_component_utils(axi_sagent_uvc)
	
	//-------component handle 
	axi_slv_config slv_config_h[];
	
	axi_env_config env_config;
	
	axi_slv_agent #(32,32,3)slv_agnt_h[];
	
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
		
	    //get environment configuration 
	    if (!uvm_config_db #(axi_env_config)::get(this,"","env_config",env_config))
	      `uvm_fatal("ENV_CONFIG_GET","ENV config is not available")
	    
		slv_config_h = new[env_config.no_of_agent];
		slv_agnt_h = new[env_config.no_of_agent];
		foreach(slv_config_h[i])begin
		  slv_config_h[i] = axi_slv_config::type_id::create($sformatf("slv_config_h[%0d]",i));
		  case(i)
 		   'h0 : begin
		           slv_config_h[i].is_active = UVM_ACTIVE;
				   slv_agnt_h[i] = axi_slv_agent #(32,32,3)::type_id::create($sformatf("slv_agnt_h[%0d]",i),this); 
		           uvm_config_db #(axi_slv_config)::set(this,"slv_agnt_h[0]*","slv_config",slv_config_h[0]);
				 end
		   'h1 : begin
		           slv_config_h[i].is_active = UVM_PASSIVE;
				   slv_agnt_h[i] = axi_slv_agent #(32,32,3)::type_id::create($sformatf("slv_agnt_h[%0d]",i),this); 
		           uvm_config_db #(axi_slv_config)::set(this,"slv_agnt_h[1]*","slv_config",slv_config_h[1]);
				 end
		  endcase
		   //if(slv_agnt_h[i] != null) begin
		    // $display(" %0d This is slv agent uvc build phase",i);
		     slv_agnt_h[i].set_index(i);
		  // end
		   uvm_config_db #(axi_slv_config)::set(this,$sformatf("slv_agnt_h[i]",i),"slv_config",slv_config_h[i]);
		end //foreach

	endfunction 
	
endclass 

`endif 
	
	
	

	
	
	