/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_BASE_SEQ
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////
`ifndef AXI_SLV_BASE_SEQ_SV
`define AXI_SLV_BASE_SEQ_SV

class axi_slv_base_seq #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_sequence #(axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE));

	//factory registration--------
	`uvm_object_param_utils(axi_slv_base_seq #(ADDR_WIDTH,DATA_WIDTH,SIZE))
	
	//
	rand int no_of_iteration;
	
	int count;
	 
	//-------constructor 
	function new(string name = "");
		super.new(name);
	endfunction
	
	task wait_for_trans_done(int no_of_iteration);
		wait(count == no_of_iteration);
		count = 0;
	endtask 
	
	function void response_handler(uvm_sequence_item response);
	  count++;
	  $display($time," : response_handler count %0d",count);
	endfunction 
	
endclass : axi_slv_base_seq

`endif