/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_SEQR
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SLV_SEQR_SV
`define AXI_SLV_SEQR_SV

class axi_slv_seqr #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_sequencer #(axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE));

	//for multiple agent/driver indentify
	int index;
	
	uvm_analysis_export #(axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)) item_req_export;
	
	uvm_tlm_analysis_fifo  #(axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)) item_req_fifo;
	// Factory registeration
  `uvm_component_param_utils_begin(axi_slv_seqr #(ADDR_WIDTH,DATA_WIDTH,SIZE))
	`uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
  `uvm_component_utils_end
  
	//////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
	function new (string name = "", uvm_component parent = null);
		super.new(name,parent);
		item_req_export = new("item_req_export",this);
		item_req_fifo = new("item_req_fifo",this);
	endfunction
	
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void set_index(int index);
     this.index = index;
   endfunction
	
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
	 item_req_export.connect(item_req_fifo.analysis_export);
   endfunction

endclass

`endif
