/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_ENV_CONFIG
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_ENV_CONFIG_SVH
`define AXI_ENV_CONFIG_SVH

class axi_env_config extends uvm_object;
   
   int no_of_agent=1;   
   
  //Factory Registeration
   `uvm_object_utils_begin(axi_env_config)
     `uvm_field_int(no_of_agent, UVM_ALL_ON | UVM_DEC)
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