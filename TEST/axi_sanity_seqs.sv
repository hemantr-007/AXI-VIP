/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_SANITY
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SANITY_SEQS_SV
`define AXI_SANITY_SEQS_SV
`include "axi_mas_define.sv"
//test case
class axi_mas_sanity_seqs extends axi_mas_base_seq #(32,32,3);
	//-------factory registration
	`uvm_object_utils(axi_mas_sanity_seqs)

	axi_mas_seq_item #(32,32,3) trans_h;
	//axi_slv_seq_item #(32,32,3) trans_h;

	//-------constructor 
	function new(string name = "");
		super.new(name);
	endfunction 
	
	task body();
		repeat(10)begin
			 `uvm_do_with(trans_h,{start_addr == 'hBA; no_of_bytes == 3; burst_type_e == INCR; AW_LEN==5;});
			// $display("this is body of sanity sequence after randomization----------------------");
   			//  trans_h.AW_ADDR_q = $random;
		//	  trans_h.AW_LEN = $random;
			  trans_h.print();
			//  $display("sanity_seqs");
			  //#200;//raise and drop objection delay
		      //wait_for_trans_done(1);
		end
	endtask
	
endclass : axi_mas_sanity_seqs

`endif 