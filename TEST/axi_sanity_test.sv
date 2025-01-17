/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SANITY_TEST
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SANITY_TEST_SV
`define AXI_SANITY_TEST_SV

class axi_sanity_test extends axi_base_test;
	
	//-------factory registration
	`uvm_component_utils(axi_sanity_test)

	axi_mas_sanity_seqs seqs_h;
	//-------constructor 
	function new(string name = "", uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
	task run_phase(uvm_phase phase);
	        phase.raise_objection(this, "AXI_SANITY_TEST STARTED"); 	
			seqs_h=axi_mas_sanity_seqs::type_id::create("seqs_h");
			void'(seqs_h.randomize());
			if(env_h.mas_uvc.mas_agnt_h[0].mas_seqr_h != null)
			$display("env_h.mas_uvc.mas_agnt_h[0].mas_seqr_h is not null--------------------");
			seqs_h.start(env_h.mas_uvc.mas_agnt_h[0].mas_seqr_h);
	        phase.drop_objection(this, "AXI_SANITY_TEST ENDED");  
	    	phase.phase_done.set_drain_time(this,1000);
	endtask
	
	
endclass : axi_sanity_test

`endif 