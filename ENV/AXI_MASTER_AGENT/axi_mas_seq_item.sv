/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_SEQ_ITEM
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_SEQ_ITEM_SV
`define AXI_MAS_SEQ_ITEM_SV

//`include "axi_mas_define.sv"
  //Assuming enums are defined somewhere in your code
  typedef enum bit [1:0] {SINGLE, INCR, WRAP} burst_type;
  typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR} resp_type;
  
class axi_mas_seq_item #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 4) extends uvm_sequence_item;

  // Enum to set type of burst i.e. SINGLE, INCR, WRAP
  rand burst_type burst_type_e;
  
  // Enum to set type of response i.e OKAY, EXOKAY, SLVERR, DECERR
  rand resp_type resp_type_e;
  
   // Set no_of_bytes for each transaction (i.e. 2**size)
  rand bit [7:0] no_of_bytes;

  //To set Starting address of a burst transaction
  rand bit [(ADDR_WIDTH-1):0] start_addr;
  
  // WRITE_ADDRESS CHANNEL:
  rand bit [(ADDR_WIDTH-1):0] AW_ADDR_q[$];
  
  // Write_address identifier
  rand bit [SIZE:0] AW_ID;
  
  // Burst_length = number of data transfer associated with address.
  rand bit [SIZE-1:0] AW_LEN;
  
  // Burst type: Details how the address for each transfer within the burst is calculated.
  rand bit [(SIZE-3):0] AW_BURST; //type enum burst
  
  // Burst size = indicate size of each transfer in the burst.
  rand bit [(SIZE-2):0] AW_SIZE;
  
  // WRITE_DATA CHANNEL:
  // Write_data for manager
  rand bit [(DATA_WIDTH-1):0] W_DATA[$];
  
  // Write_strobe: This signal indicates which byte lanes to update in memory.
  // strobe is used for mainly there are many or more master and slave in between interconnect
  //and which master sent data to which slave that decide by strobe.
  rand bit [(DATA_WIDTH/8)-1:0] W_STRB;
  
  // Write_last: indicate last transfer in write burst;
  bit W_LAST;

  // Write_id: ID tag for write data transfer (must match WID value to AWID)
  rand bit [SIZE-1:0] W_ID;
  
  // WRITE_RESPONSE CHANNEL: The identification tag of the write response.
  rand bit [SIZE-1:0] B_ID;
  bit [1:0] B_RESP; //type enum rsp
  
  // READ_ADDRESS CHANNEL:
  rand bit [(ADDR_WIDTH-1):0] AR_ADDR_q[$];
  rand bit [(SIZE-1):0] AR_ID;
  rand bit [(SIZE-3):0] AR_BURST; //type burst enum 
  rand bit [(SIZE-1):0] AR_LEN;
  rand bit [(SIZE-2):0] AR_SIZE;
  
  // READ DATA CHANNEL:
  bit [(SIZE-1):0] R_ID;
  
  bit [1:0] R_RESP; //type rsp_type not bit
  // resp_type R_RESP; //type rsp_type not bit
  bit [(DATA_WIDTH-1):0] R_DATA[$];
  bit R_LAST;
  
  //To set length of a burst transaction
  // For SINGLE it must be set to 1
  // For WRAP it must be set to 4, 8, 16
  // For INCR it must be set to 4, 8, 16, UNDEFINE
  rand shortint unsigned burst_len;
 
   rand  bit[7:0] byte_lane;
   bit[31:0] Lower_Wrap_Boundary;
   bit [31:0]  Upper_Wrap_Boundary;
   
  // Factory Registration and Field Macros
  `uvm_object_param_utils_begin(axi_mas_seq_item #(ADDR_WIDTH, DATA_WIDTH, SIZE))
         
		 `uvm_field_enum(burst_type, burst_type_e, UVM_ALL_ON)
         `uvm_field_enum(resp_type, resp_type_e, UVM_ALL_ON)
	 
	     `uvm_field_int(no_of_bytes, UVM_ALL_ON)
	     `uvm_field_int(start_addr, UVM_ALL_ON)
		 
	     `uvm_field_int(AW_ID, UVM_ALL_ON)
	     `uvm_field_int(AW_LEN, UVM_ALL_ON)
	     `uvm_field_int(AW_BURST, UVM_ALL_ON)
	     `uvm_field_int(AW_SIZE, UVM_ALL_ON)
		 `uvm_field_queue_int(AW_ADDR_q, UVM_ALL_ON)
	 
	     `uvm_field_int(W_ID, UVM_ALL_ON)
	     `uvm_field_queue_int(W_DATA, UVM_ALL_ON)
	     `uvm_field_int(W_STRB, UVM_ALL_ON)
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
	     `uvm_field_int(byte_lane, UVM_ALL_ON )
  `uvm_object_utils_end
  
  //construct 
  function new(string name = "axi_mas_seq_item");
     super.new(name);
  endfunction
  
  //post randomize
  function void post_randomize();

	axi_burst_calculation();
    //axi_strobe_calculation();
  endfunction
 
  // Add constraints if any
 // constraint axi_size_con{axi_size_e inside {a1,a2,a4};} //DATA_WIDTH/8 (have to transfer minimum 8 byte thats why we take /8) 
  constraint axi_size_e{W_DATA.size() == AW_LEN;
						  solve burst_len before W_DATA;
						//  axi_mas_vif.slv_drv_cb.AWREADY == axi_mas_vif.slv_drv_cb.WREADY;	
						  } //DATA_WIDTH/8 (have to transfer minimum 8 byte thats why we take /8) 
  //total byte:-total_byte = no of byte * burst_len
 
  // Other constraints or member variables
  constraint BURST_LEN{solve burst_type_e before burst_len;
					   if(burst_type_e == SINGLE){
							AW_LEN == 1;}
					   else if(burst_type_e == INCR){
							AW_LEN inside {1,2,4,8,16};
							}
					   else if(burst_type_e == WRAP){
							AW_LEN inside {2,4,8,16};
						}
				  }
 
/*  //TODO
  function void axi_strobe_calculation();
		int j;
		bit [(DATA_WIDTH/8)-1:0] start_lan;
		
		repeat(burst_len)begin
		start_lan = start_addr%8;
		j = start_lan% no_of_bytes; // j = lan 
		//	for(int i=j; i<no_of_bytes; i++) begin
				W_STRB = 1'b1;
				start_lan++;
			if (start_lan == ((DATA_WIDTH/8)))
				start_lan=0;
				j=0;
			end
		end
		end
  endfunction
   */
  function void axi_burst_calculation();
	     
		 bit[7:0] axi_size_e = no_of_bytes * burst_len;
		 AW_ADDR_q[0] = start_addr;
		
		 //FOR INCREMENTAL ADDRESS
               	if(burst_type_e == INCR) 
               		AW_ADDR_q[0] = start_addr;
               	
               	 for (int i = 1; i < AW_LEN; i++)
				   begin
                     // Calculate the next address
                     AW_ADDR_q[i] = AW_ADDR_q[i-1] + no_of_bytes;
               	   end
                  
				  
				  
				   //FOR WRAP 
                     	if(burst_type_e == WRAP) begin
                     	no_of_bytes = (2 ** AW_SIZE);  //awsize getting from the user

                         Lower_Wrap_Boundary = ((int'(AW_ADDR_q[0]/axi_size_e)) * axi_size_e);
		
 			             Upper_Wrap_Boundary = Lower_Wrap_Boundary + axi_size_e;
			           end

    ///////////////////ARADDR
    ///////////////////////////////////////////////////////
    //
    	
		// Initial address
       AR_ADDR_q[0] = start_addr;

                if(burst_type_e == INCR) 
               		AR_ADDR_q[0] = start_addr;
               	
               	 for (int i = 1; i < AR_LEN; i++)
				   begin
                     // Calculate the next address
                     AR_ADDR_q[i] = AR_ADDR_q[i-1] + no_of_bytes;
               	   end
                  
				   //FOR WRAP 
                     	if(burst_type_e == WRAP) begin
                     	no_of_bytes = (2 ** AR_SIZE);  //awsize getting from the user

                         Lower_Wrap_Boundary = ((int'(AR_ADDR_q[0]/axi_size_e)) * axi_size_e);
		
 			             Upper_Wrap_Boundary = Lower_Wrap_Boundary + axi_size_e;
			     end
			
  endfunction
  
endclass : axi_mas_seq_item

`endif

/*  DataTransfer(Start_Address, Number_Bytes, Burst_Length, Data_Bus_Bytes, Mode, IsWrite)
 // Data_Bus_Bytes is the number of 8-bit byte lanes in the bus
 // Mode is the AXI transfer mode
 // IsWrite is TRUE for a write, and FALSE for a read  */