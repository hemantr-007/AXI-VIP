/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_AGENT
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SLV_AGENT_SV
`define AXI_SLV_AGENT_SV

class axi_slv_agent #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_agent;
  
  int index;
  axi_slv_config slv_config_h;
  int b;
  //Factory Registration
  `uvm_component_param_utils_begin(axi_slv_agent #(ADDR_WIDTH,DATA_WIDTH,SIZE))
	`uvm_field_int(index, UVM_ALL_ON |  UVM_DEC)
	`uvm_field_object(slv_config_h, UVM_ALL_ON)
  `uvm_component_utils_end
  
  //virtual interface
  virtual axi_slv_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE) axi_slv_vif;
  
  //handle of components and config 
  axi_slv_driver  #(ADDR_WIDTH,DATA_WIDTH,SIZE)  slv_drv_h;
  
  axi_slv_monitor #(ADDR_WIDTH,DATA_WIDTH,SIZE)  slv_mon_h;
  
  axi_slv_seqr    #(ADDR_WIDTH,DATA_WIDTH,SIZE)  slv_seqr_h;
  
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
   // Discription :
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
	 slv_config_h = axi_slv_config::type_id::create("slv_config_h",this);
	 //$display("THIS IS slave agent BUILD PHASE");
	 //get master configuration 
	 if(!uvm_config_db #(axi_slv_config)::get(this,"","slv_config",slv_config_h))
	   `uvm_fatal("AGENT_CONFIG_GET","slave config is not available")
	 	//$display("slv_config_h.is_active = %0s",slv_config_h.is_active);
	 //if agent is active create driver and sequencer 
	  if(slv_config_h.is_active == UVM_ACTIVE)begin
	  // $display("this is active display");
	   slv_seqr_h = axi_slv_seqr  #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("slv_seqr_h",this);
	   slv_seqr_h.set_index(index);
	   slv_drv_h = axi_slv_driver #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("slv_drv_h",this);
	   slv_drv_h.set_index(index);
	 end  
	 //create monitor 
	 slv_mon_h = axi_slv_monitor#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("slv_mon_h",this);
	 slv_mon_h.set_index(index);
	 
	  if(!uvm_config_db #(int)::get(this,"","A",b))
		$display("b is not get");
	 else 
		$display("b is %0p",b);
	 //get virtual interface 
	 if(!uvm_config_db #(virtual axi_slv_inf#(ADDR_WIDTH,DATA_WIDTH,SIZE))::get(this,"","axi_slv_vif",axi_slv_vif))
	    `uvm_fatal("AGNET_VIRTUAL_INTERFACE","slave Interface is not available")
	
   endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	//if agent is active connect driver port and sequencer export 
	//and connect driver interface with this interface 
	if(slv_config_h.is_active == UVM_ACTIVE) begin
	  slv_drv_h.seq_item_port.connect(slv_seqr_h.seq_item_export); 
	  slv_drv_h.axi_slv_vif = this.axi_slv_vif; 
	  $display(" Inside connect %0d",index);
	  end
	 // slv_mon_h.item_req_port.connect(slv_mon_h.seq_item_export);
	  //connect master interface with this interface 
	  slv_mon_h.axi_slv_vif = this.axi_slv_vif;
	
   endfunction
   
endclass

`endif
  