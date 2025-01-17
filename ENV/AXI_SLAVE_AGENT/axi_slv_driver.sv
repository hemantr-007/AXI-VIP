/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_DRIVER
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////
`ifndef AXI_SLV_DRIVER_SV
`define AXI_SLV_DRIVER_SV

class axi_slv_driver #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_driver #(axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE),axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE));
  
  //to indentify driver
  int index;
  
  //Factory Registration-----
  `uvm_component_param_utils_begin(axi_slv_driver#(ADDR_WIDTH,DATA_WIDTH,SIZE))
		`uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
  `uvm_component_utils_end
  
  //virtual interface
   virtual axi_slv_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE)axi_slv_vif;
    
    axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_response_channel_q[$];
	axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)read_data_channel_q[$];
   /////////////////////////////////////////
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
	// $display("this is slv driver display");
     super.build_phase(phase);
	 endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   task run_phase(uvm_phase phase);	
		forever begin
				 $display("********slave DRIVER********");
				 //`uvm_info(get_type_name(),$sformatf("req.print %0s",req.sprint()),UVM_LOW)
				  // write_response_channel_q.push_back(req);
				  // read_data_channel_q.push_back(req);
	          simple_test();
			end
			//  write_response();
			 // read_data();

   endtask
  
   //write a channel of write response and read data.........
   task simple_test();
		  fork 
            	begin
            	    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.slv_drv_cb.AWVALID);
            	    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.WVALID);
            	    axi_slv_vif.slv_drv_cb.AWREADY <= 1'b1;
            	end
				
				begin 
            	    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.slv_drv_cb.AWVALID);
            	    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.WVALID);
            	    axi_slv_vif.slv_drv_cb.WREADY <= 1'b1;
				end
			
				begin
				    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.slv_drv_cb.AWVALID);
					@(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.WVALID);
            	    axi_slv_vif.slv_drv_cb.AWREADY <= 1'b1;
            	    axi_slv_vif.slv_drv_cb.WREADY <= 1'b1;
					axi_slv_vif.slv_drv_cb.BVALID  <= 1'b1;
				end
				
				begin 
				    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.WVALID);
					axi_slv_vif.slv_drv_cb.WREADY <= 1'b1;
					axi_slv_vif.slv_drv_cb.BVALID  <= 1'b1;
            	    @(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.BREADY);
				end
			 
				begin
					@(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.slv_drv_cb.AR_VALID);
		    	    axi_slv_vif.slv_drv_cb.AR_READY <= 1'b1;	
					axi_slv_vif.slv_drv_cb.RVALID  <= 1'b1;
		       	end
				
				begin 
				    axi_slv_vif.slv_drv_cb.RVALID  <= 1'b1;
					@(posedge axi_slv_vif.slv_drv_cb iff axi_slv_vif.slv_drv_cb.RREADY);
				end
		join
   endtask

   
   task write_response();
		axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) wr_response_channel;
		@(posedge axi_slv_vif.slv_drv_cb);
		forever begin
			axi_slv_vif.slv_drv_cb.BVALID <= 1'b0;
		    wait(write_response_channel_q.size() != 0);
			wr_response_channel = write_response_channel_q.pop_front();			
			for(int i = 0; i<=req.AW_LEN; i++)begin
				axi_slv_vif.slv_drv_cb.BVALID <= 1'b1;
				axi_slv_vif.slv_drv_cb.B_ID <= wr_response_channel.B_ID;
				axi_slv_vif.slv_drv_cb.B_RESP <= wr_response_channel.B_RESP;
				wait(axi_slv_vif.slv_drv_cb.BREADY);
		    end
		end
   endtask 
   
   task read_data();
	   axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) rd_data_channel;
	   @(posedge axi_slv_vif.slv_drv_cb);
	   forever begin
	     wait(read_data_channel_q.size() != 0);
		 rd_data_channel = read_data_channel_q.pop_front();
		 for(int i = 0; i<=req.AW_LEN; i++)begin
			axi_slv_vif.slv_drv_cb.RVALID <= 1'b1;
			axi_slv_vif.slv_drv_cb.R_ID <= rd_data_channel.R_ID;
			axi_slv_vif.slv_drv_cb.R_RESP <= rd_data_channel.R_RESP;
			axi_slv_vif.slv_drv_cb.R_DATA <= rd_data_channel.R_DATA.pop_front();
			if(i == req.AW_LEN-1)begin
			axi_slv_vif.slv_drv_cb.R_LAST <= 1'b1;
			end else begin 
			axi_slv_vif.slv_drv_cb.R_LAST <= 1'b0; end 
			wait(axi_slv_vif.slv_drv_cb.RREADY);
		 end
	   end
   endtask 

 endclass

`endif
  