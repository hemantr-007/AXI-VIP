/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_AGENT
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_AGENT_SV
`define AXI_MAS_AGENT_SV

class axi_mas_agent #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_agent;
  
  int index;
  axi_mas_config mas_config_h;
  
  //Factory Registration
  `uvm_component_param_utils_begin(axi_mas_agent #(ADDR_WIDTH,DATA_WIDTH,SIZE))
	`uvm_field_int(index, UVM_ALL_ON |  UVM_DEC)
	`uvm_field_object(mas_config_h, UVM_ALL_ON)
  `uvm_component_utils_end
  
  //virtual interface
  virtual axi_mas_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE) axi_mas_vif;
  
  //handle of components and config 
  axi_mas_driver  #(ADDR_WIDTH,DATA_WIDTH,SIZE)  mas_drv_h;
  
  axi_mas_monitor #(ADDR_WIDTH,DATA_WIDTH,SIZE)  mas_mon_h;
  
  axi_mas_seqr    #(ADDR_WIDTH,DATA_WIDTH,SIZE)  mas_seqr_h;
  
   //////////////////////////////////////////--
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function new (string name="", uvm_component parent = null);
     super.new(name, parent);
   endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription : to know that howmany driver and monitor should be created...
   ///////////////////////////////////////////
   function void set_index(int index);
     this.index = index;
   endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
	 
	 //create handle of master config 
	 mas_config_h = axi_mas_config::type_id::create("mas_config_h",this);
	 
	 //get master configuration 
	 if(!uvm_config_db #(axi_mas_config)::get(this,"","mas_config",mas_config_h))
	   `uvm_fatal("AGENT_CONFIG_GET","Master config is not available")
	 	$display("mas_config_h.is_active = %0s",mas_config_h.is_active); 
	 //if agent is active create driver and sequencer 
	  if(mas_config_h.is_active == UVM_ACTIVE) begin
	  // $display("this is active display");
	   mas_seqr_h = axi_mas_seqr  #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mas_seqr_h",this);
	   mas_seqr_h.set_index(index);
	   mas_drv_h = axi_mas_driver #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mas_drv_h",this);
	   mas_drv_h.set_index(index);
	 end 
	 //end	 
	 //create monitor 
	 mas_mon_h = axi_mas_monitor#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mas_mon_h",this);
	 mas_mon_h.set_index(index);
	 
	 //get virtual interface 
	 if(!uvm_config_db #(virtual axi_mas_inf#(ADDR_WIDTH,DATA_WIDTH,SIZE))::get(this,"","axi_mas_vif",axi_mas_vif))
	    `uvm_fatal("AGNET_VIRTUAL_INTERFACE","Master Interface is not available")
	 
   endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	
	//if agent is active connect driver port and sequencer export 
	//and connect driver` interface with this interface 
	if(mas_config_h.is_active == UVM_ACTIVE) begin 
	  mas_drv_h.seq_item_port.connect(mas_seqr_h.seq_item_export); 
	  mas_drv_h.axi_mas_vif = this.axi_mas_vif; 
	end 
	//connect master interface with this interface 
	mas_mon_h.axi_mas_vif = this.axi_mas_vif;
	
   endfunction
   
endclass

`endif




  