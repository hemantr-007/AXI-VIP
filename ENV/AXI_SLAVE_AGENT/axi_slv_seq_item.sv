/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLAVE_SEQ_ITEM
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////
`ifndef AXI_SLV_SEQ_ITEM_SV
`define AXI_SLV_SEQ_ITEM_SV

// Assuming enums are defined somewhere in your code
  typedef enum bit [1:0] {SINGLE, INCR, WRAP} burst_type;
  typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR} resp_type;

class axi_slv_seq_item #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_sequence_item;
 
  // Enum to set type of burst i.e. SINGLE, INCR, WRAP
  rand burst_type burst_type_e;
  
  // Enum to set type of response i.e OKAY, EXOKAY, SLVERR, DECERR
   rand resp_type resp_type_e;
  
  // Set no_of_bytes for each transaction (i.e. 2**size)
  rand bit [7:0] no_of_bytes;
  
  
  // WRITE_ADDRESS CHANNEL:
  // Write address for manager
  rand bit [(ADDR_WIDTH-1):0] AW_ADDR_q[$];
  
  // Write_address identifier
   rand bit [SIZE :0] AW_ID;
  
  // Burst_length = number of data transfer associated with address.
  rand bit [SIZE:0] AW_LEN;
  
  // Burst type: Details how the address for each transfer within the burst is calculated.
  rand bit [(SIZE-2):0] AW_BURST; //type enum burst
  
  // Burst size = indicate size of each transfer in the burst.
   rand bit [(SIZE-1):0] AW_SIZE;
  
  // WRITE_DATA CHANNEL:
  // Write_data for manager
  rand bit [(DATA_WIDTH-1):0] W_DATA[$];
  
  // Write_strobe: This signal indicates which byte lanes to update in memory.
  // strobe is used for mainly there are many or more master and slave in between interconnect
  //and which master sent data to which slave that decide by strobe.
   bit [SIZE:0] W_STRB[$];
  
  // Write_last: indicate last transfer in write burst;
   bit W_LAST;
  
  // Write_id: ID tag for write data transfer (must match WID value to AWID)
  rand bit [SIZE:0] W_ID;
  
  // WRITE_RESPONSE CHANNEL: The identification tag of the write response.
   bit [SIZE:0] B_ID;
   bit [1:0] B_RESP; //type enum rsp
   
  // READ_ADDRESS CHANNEL:
   rand bit [(ADDR_WIDTH-1):0] AR_ADDR_q[$];
   rand bit [SIZE:0] AR_ID;
   rand bit [(SIZE-2):0] AR_BURST; //type burst enum 
   rand bit [SIZE:0] AR_LEN;
   rand bit [(SIZE-1):0] AR_SIZE;
  
  // READ DATA CHANNEL:
   bit [SIZE:0]R_ID;
   bit [1:0] R_RESP; //type rsp_type not bit
  //resp_type R_RESP; //type rsp_type not bit
   bit [(DATA_WIDTH-1):0] R_DATA[$];
   bit R_LAST;
   
  //To set Starting address of a burst transaction
   rand bit [(ADDR_WIDTH - 1): 0] start_addr;/////////////////////////////////////////////////
   rand shortint unsigned burst_len;
   rand bit [7:0] byte_lane;
   bit [(ADDR_WIDTH-1) : 0]Lower_Wrap_Boundary;
   bit [(ADDR_WIDTH-1) : 0]Upper_Wrap_Boundary;
  //To set length of a burst transaction
  // For SINGLE it must be set to 1
  // For WRAP it must be set to 4, 8, 16
  // For INCR it must be set to 4, 8, 16, UNDEFINE
	
 
  // Factory Registration and Field Macros
  `uvm_object_param_utils_begin(axi_slv_seq_item #(ADDR_WIDTH, DATA_WIDTH, SIZE))
         
		 `uvm_field_enum(burst_type, burst_type_e, UVM_ALL_ON)
         `uvm_field_enum(resp_type, resp_type_e, UVM_ALL_ON)
	 
	     `uvm_field_int(no_of_bytes, UVM_ALL_ON)
	     `uvm_field_int(start_addr, UVM_ALL_ON)/////////////////////////////////////
	     `uvm_field_int(burst_len,UVM_ALL_ON)
		 
	     `uvm_field_int(AW_ID, UVM_ALL_ON)
	     `uvm_field_int(AW_LEN, UVM_ALL_ON)
	     `uvm_field_int(AW_BURST, UVM_ALL_ON)
	     `uvm_field_int(AW_SIZE, UVM_ALL_ON)
	     `uvm_field_queue_int(AW_ADDR_q, UVM_ALL_ON)
	 
	     `uvm_field_int(W_ID, UVM_ALL_ON)
	     `uvm_field_queue_int(W_DATA, UVM_ALL_ON)
	     `uvm_field_queue_int(W_STRB, UVM_ALL_ON)
	     `uvm_field_int(W_LAST, UVM_ALL_ON)
	 
	     `uvm_field_int(B_ID, UVM_ALL_ON)
	     `uvm_field_int(B_RESP, UVM_ALL_ON)
	 
	     `uvm_field_int(AR_ID, UVM_ALL_ON)
	     `uvm_field_int(AR_LEN, UVM_ALL_ON)
	     `uvm_field_int(AR_BURST, UVM_ALL_ON)
	     `uvm_field_int(AR_SIZE, UVM_ALL_ON)
	     `uvm_field_queue_int(AR_ADDR_q, UVM_ALL_ON)
	 
	     `uvm_field_int(R_ID, UVM_ALL_ON)
	     `uvm_field_int(R_RESP, UVM_ALL_ON)
	     `uvm_field_queue_int(R_DATA, UVM_ALL_ON)
	     `uvm_field_int(R_LAST, UVM_ALL_ON)
		 
		 `uvm_field_int(burst_len, UVM_ALL_ON | UVM_UNSIGNED)
	 
  `uvm_object_utils_end
  
  //construct 
  function new(string name = "axi_mas_seq_item");
     super.new(name);
  endfunction
   
   constraint axi_size_e{W_DATA.size() == AW_LEN;
						  solve burst_len before W_DATA;}
   
   constraint con2 { B_ID == W_ID;
					 solve W_ID before B_ID;
					}
			
  
  //post randomize
  function void post_randomize();
  
	burst_calculation();
	
  endfunction
   
   function void burst_calculation();
  
			bit[7:0] data_size = no_of_bytes * burst_len; 
			// Initial address
			AW_ADDR_q[0] = start_addr;
		    no_of_bytes = 2**AW_SIZE;
			burst_len = no_of_bytes * AW_LEN;
			// FOR INCREMENTAL ADDRESS
			if (burst_type_e == INCR) 
				AW_ADDR_q[0] = start_addr;
				
			for (int i = 1; i < AW_LEN; i++) begin
				// Calculate the next address
				AW_ADDR_q[i] = AW_ADDR_q[i-1] + no_of_bytes;
			end
		
			// FOR WRAP
			if (burst_type_e == WRAP) begin
				no_of_bytes = (2 ** AW_SIZE);  // awsize getting from the user
				lower_boundry = ((int'(AW_ADDR_q[0] / data_size)) * data_size);
				upper_boundry = lower_boundry + data_size;
			end
			
   endfunction
		
 // constraint axi_size_con{axi_size_e inside {a1,a2,a4};} //DATA_WIDTH/8 (have to transfer minimum 8 byte thats why we take /8) 
 //DATA_WIDTH/8 (have to transfer minimum 8 byte thats why we take /8) 
  //total byte:-total_byte = no of byte * burst_len
 
  // Other constraints or member variables
  constraint BURST_LEN{
					   if(burst_type_e == SINGLE){
							burst_len == 1;}
					   else if(burst_type_e == INCR){
							burst_len inside {2,4,8,16};
							}
					   else if(burst_type_e == WRAP){
							burst_len <= 16;
						}
				  }

endclass : axi_slv_seq_item

`endif
