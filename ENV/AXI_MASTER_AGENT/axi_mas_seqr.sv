/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_SEQR
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_SEQR_SV
`define AXI_MAS_SEQR_SV

class axi_mas_seqr #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_sequencer #(axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE));

	//for multiple agent/driver indentify
	int index;
	
	// Factory registeration
    `uvm_component_param_utils_begin(axi_mas_seqr #(ADDR_WIDTH,DATA_WIDTH,SIZE))
	   `uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
    `uvm_component_utils_end
  
   //////////////////////////////////////////
   // Name        :	CONSTRUCT DEFAULT
   // Arguments   : TWO ARG.
   // Discription : 
   ///////////////////////////////////////////
	function new (string name = "", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
   //////////////////////////////////////////
   // Name        : INDEX_SET
   // Arguments   : ONE ARG.
   // Discription :
   ///////////////////////////////////////////
   function void set_index(int index);
     this.index = index;
   endfunction
   
   //////////////////////////////////////////
   // Name        : CONNECT_PHASE
   // Arguments   : ONE AGR.
   // Discription :
   ///////////////////////////////////////////
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
   endfunction

endclass

`endif
