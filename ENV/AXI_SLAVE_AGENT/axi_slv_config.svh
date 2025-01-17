/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_CONFIG
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SLV_CONFIG_SVH
`define AXI_SLV_CONFIG_SVH

class axi_slv_config extends uvm_object;
 
   //To set AXI Master agent mode i.e. ACTIVE, PASSIVE
   uvm_active_passive_enum is_active=UVM_ACTIVE;
   
   //To set No of AXI Master Agent
   static int no_of_agts=1;   //TODO
   
  //Factory Registeration
  `uvm_object_utils_begin(axi_slv_config)
  `uvm_field_int(no_of_agts, UVM_ALL_ON | UVM_DEC)
  `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_object_utils_end
  
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function new (string name="");
     super.new(name);
   endfunction
   
endclass

`endif