/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_DRIVER
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_DRIVE_SV
`define AXI_MAS_DRIVE_SV
`include "axi_mas_inf.sv"
class axi_mas_driver #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_driver #(axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE),axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE));
  
  //to indentify driver
  int index;
  //Factory Registration-----
  `uvm_component_param_utils_begin(axi_mas_driver #(ADDR_WIDTH,DATA_WIDTH,SIZE))
		`uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
  `uvm_component_utils_end
  
  //virtual interface
   virtual axi_mas_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE) axi_mas_vif;
   
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_request_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_data_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_response_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)read_data_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)read_request_channel_q[$];
   
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)mas_seq_h;
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
     super.build_phase(phase);
	 mas_seq_h = axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mas_seq_h");
	 endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   
   task run_phase(uvm_phase phase);	
		fork 
			forever begin
				$display("********MASTER DRIVER********");
				seq_item_port.get(mas_seq_h);
				`uvm_info(get_type_name(),$sformatf("req.print %0s",mas_seq_h.sprint()),UVM_LOW)
				fork
				write_request_channel_q.push_back(mas_seq_h);
				write_data_channel_q.push_back(mas_seq_h);
				write_response_channel_q.push_back(mas_seq_h);
				read_request_channel_q.push_back(mas_seq_h);
				read_data_channel_q.push_back(mas_seq_h);
				join
		    end
            send_to_dut();
		join
   endtask
	   task send_to_dut();
		   fork
		    write_request();
		    write_data();
		    write_response();
		    read_request();
			read_data();
		   join
		endtask 
   //write_request/address channel task 
   task write_request();
	   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)wr_request_channel;
	  @(posedge axi_mas_vif.mas_drv_cb);
			forever begin
				wait(write_request_channel_q.size()!= 0); 
				wr_request_channel = write_request_channel_q.pop_front();
						axi_mas_vif.mas_drv_cb.AWVALID <= 1'b1;
						axi_mas_vif.mas_drv_cb.WVALID <= 1'b1;
						@(posedge axi_mas_vif.mas_drv_cb iff axi_mas_vif.mas_drv_cb.AWREADY);
						axi_mas_vif.mas_drv_cb.AW_ID   <= wr_request_channel.AW_ID;
						axi_mas_vif.mas_drv_cb.AW_LEN  <= wr_request_channel.AW_LEN;
						axi_mas_vif.mas_drv_cb.AW_BURST<= wr_request_channel.AW_BURST;
						axi_mas_vif.mas_drv_cb.AW_SIZE <= wr_request_channel.AW_SIZE;
						axi_mas_vif.mas_drv_cb.AW_ADDR_q <= wr_request_channel.AW_ADDR_q.pop_front();
				$display("write_request master");
			end
   endtask
   
   //write_data channel task 
   task write_data();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)wr_data_channel; 
		@(posedge axi_mas_vif.mas_drv_cb);
		forever begin
		    wait(write_data_channel_q.size() != 0);
			wr_data_channel = write_data_channel_q.pop_front();
			for(int i = 0; i<=mas_seq_h.AW_LEN-1; i++)begin
				axi_mas_vif.mas_drv_cb.AWVALID <= 1'b1;
			    axi_mas_vif.mas_drv_cb.WVALID <= 1'b1;
				@(posedge axi_mas_vif.mas_drv_cb iff axi_mas_vif.WREADY);
			    axi_mas_vif.mas_drv_cb.W_ID    <= wr_data_channel.W_ID;
				axi_mas_vif.mas_drv_cb.W_DATA  <= wr_data_channel.W_DATA.pop_front();
				axi_mas_vif.mas_drv_cb.W_STRB   <= wr_data_channel.W_STRB;
				if(i == mas_seq_h.AW_LEN-1)
					axi_mas_vif.mas_drv_cb.W_LAST <= 1'b1;
				else
				    axi_mas_vif.mas_drv_cb.W_LAST <= 1'b0;
			end
			 //   axi_mas_vif.mas_drv_cb.WVALID <= 1'b0;
			    $display("write_data master");
		end
   endtask
         
   //write_response channel task 
   task write_response();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) wr_response_channel;
		@(posedge axi_mas_vif.mas_drv_cb);
		forever begin
			axi_mas_vif.mas_drv_cb.WVALID <= 1'b1;
			@(posedge axi_mas_vif.mas_drv_cb iff axi_mas_vif.BVALID);
			axi_mas_vif.mas_drv_cb.BREADY <= 1'b1;
			
			$display("write_response master");
		end
			//axi_mas_vif.mas_drv_cb.WVALID <= 1'b0;
   endtask
   
   //read_request/address channel task
   task read_request();
	   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) rd_request_channel;
	        @(posedge axi_mas_vif.mas_drv_cb);
			//axi_mas_vif.mas_drv_cb.AR_VALID <= 1'b0;
			forever begin 
				wait(read_request_channel_q.size() != 0);
				rd_request_channel = read_request_channel_q.pop_front();
				for(int i = 0; i<=mas_seq_h.AW_LEN; i++)begin
				    axi_mas_vif.mas_drv_cb.AR_VALID <= 1'b1;
					@(posedge axi_mas_vif.mas_drv_cb iff axi_mas_vif.mas_drv_cb.AR_READY);
					axi_mas_vif.mas_drv_cb.AR_ADDR_q <= rd_request_channel.AR_ADDR_q.pop_front();
					axi_mas_vif.mas_drv_cb.AR_ID   <= rd_request_channel.AR_ID;
					axi_mas_vif.mas_drv_cb.AR_LEN  <= rd_request_channel.AR_LEN;
					axi_mas_vif.mas_drv_cb.AR_SIZE <= rd_request_channel.AR_SIZE;
					axi_mas_vif.mas_drv_cb.AR_BURST <= rd_request_channel.AR_BURST;
				end
			 //   axi_mas_vif.mas_drv_cb.AR_VALID <= 1'b0;
				$display("read_request master");
	        end
   endtask
   
   //read_data channel task 
   task read_data();
	   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) rd_data_channel;
	   forever begin
			@(posedge axi_mas_vif.mas_drv_cb iff axi_mas_vif.mas_drv_cb.RVALID);
			axi_mas_vif.mas_drv_cb.RREADY <= 1'b1;
			$display("read_data master");
	   end
   endtask
 endclass

`endif
  
/* /////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_DRIVER
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_DRIVE_SV
`define AXI_MAS_DRIVE_SV

class axi_mas_driver #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_driver #(axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE),axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE));
  
  //to indentify driver
  int index;
  //Factory Registration-----
  `uvm_component_param_utils_begin(axi_mas_driver #(ADDR_WIDTH,DATA_WIDTH,SIZE))
		`uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
  `uvm_component_utils_end
  
  //virtual interface
   virtual axi_mas_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE) axi_mas_vif;
  
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_data_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_response_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)write_request_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)read_data_channel_q[$];
   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)read_request_channel_q[$];
  
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
     super.build_phase(phase);
	 endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   task run_phase(uvm_phase phase);
	  fork	
		  forever begin
		  $display("********MASTER DRIVER********");
           seq_item_port.get(req);
		   `uvm_info(get_name(),$sformatf("req.print %0s",req.sprint()),UVM_LOW)
		   $cast(rsp,req.clone());
		   rsp.set_id_info(req); 
		   write_request_channel_q.push_back(req);
		   write_data_channel_q.push_back(req);
		   write_response_channel_q.push_back(req);
		   read_request_channel_q.push_back(req);
		   read_data_channel_q.push_back(req);
		 end
         driver_channel();
      join_none
   endtask
   	//task call one by one
	task driver_channel();
		fork
			write_request();
			write_data();
			write_response();
			read_request();
			read_data();
		join_none
    endtask
 
   //write_request/address channel task 
   task write_request();
	   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)wr_request_channel;
		axi_mas_vif.mas_drv_cb.AWVALID <= 1'b0;
		//@(posedge axi_mas_vif.mas_drv_cb);
			forever begin		
				wait(write_request_channel_q.size() != 0);
				wr_request_channel = write_request_channel_q.pop_front();
				for(int i = 0; i<=req.AW_LEN-1; i++)begin
					axi_mas_vif.mas_drv_cb.AWVALID <= 1'b1;
					axi_mas_vif.mas_drv_cb.AW_ID   <= wr_request_channel.AW_ID;
					axi_mas_vif.mas_drv_cb.AW_LEN <= wr_request_channel.AW_LEN;
					axi_mas_vif.mas_drvjgfh_cb.AW_ADDR <= wr_request_channel.AW_ADDR;
					axi_mas_vif.mas_drv_cb.AW_BURST   <= wr_request_channel.AW_BURST;
					axi_mas_vif.mas_drv_cb.AW_SIZE <= wr_request_channel.AW_SIZE;	
					wait(axi_mas_vif.mas_drv_cb.AWREADY);
				end
				 //axi_mas_vif.mas_drv_cb.AWVALID <= 1'b0;
			end
   endtask
   
   //write_data channel task 
   task write_data();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)wr_data_channel; 
	//	@(posedge axi_mas_vif.mas_drv_cb);
		forever begin
			axi_mas_vif.mas_drv_cb.WVALID <= 1'b0;
		    wait(write_data_channel_q.size() != 0);
			wr_data_channel = write_data_channel_q.pop_front();
			for(int i = 0; i<=req.AW_LEN-1; i++)begin
			    axi_mas_vif.mas_drv_cb.WVALID <= 1'b1;
				@(posedge axi_mas_vif.mas_drv_cb);
			    axi_mas_vif.mas_drv_cb.W_ID    <= wr_data_channel.W_ID;
				//@(posedge axi_mas_vif.mas_drv_cb);// not synchronization happed in queue array. 
				axi_mas_vif.mas_drv_cb.W_DATA  <= wr_data_channel.W_DATA.pop_front();
				axi_mas_vif.mas_drv_cb.W_STRB   <= wr_data_channel.W_STRB;
				if(i==req.AW_LEN-1) begin
					axi_mas_vif.mas_drv_cb.W_LAST <= 1'b1;
				end 
				else begin
				    axi_mas_vif.mas_drv_cb.W_LAST <= 1'b0;
				end
			    wait(axi_mas_vif.mas_drv_cb.WREADY);// aa ek data transfer thayo kevay have biji vaar aavshe data tyare wready = 1 hashe toh te datab drive thay .
				axi_mas_vif.mas_drv_cb.WVALID <= 1'b0;
			end
		end
   endtask
   
       
   //write_response channel task 
   task write_response();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) wr_response_channel;
		@(posedge axi_mas_vif.mas_drv_cb);
		forever begin 
		    wait(write_response_channel_q.size() != 0);
			wr_response_channel = write_response_channel_q.pop_front();			
			for(int i = 0; i<=req.AW_LEN; i++)begin
			 //both are drive from slave
			 axi_mas_vif.mas_drv_cb.BREADY <= 1'b1;
				//axi_mas_vif.mas_drv_cb.B_ID    <= wr_response_channel.B_ID;
				//axi_mas_vif.mas_drv_cb.B_RESP  <= wr_response_channel.B_RESP;
				wait(axi_mas_vif.mas_drv_cb.BVALID);
				//axi_mas_vif.mas_drv_cb.BREADY <= 0'b0;
		    end
		end
   endtask
   
   //read_request/address channel task
   task read_request();
	   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) rd_request_channel;
			forever begin 
				wait(read_request_channel_q.size() != 0);
				rd_request_channel = read_request_channel_q.pop_front();
				for(int i = 0; i<=req.AW_LEN; i++)begin
					axi_mas_vif.mas_drv_cb.AR_VALID <= 1'b1;
					@(posedge axi_mas_vif.mas_drv_cb);
					axi_mas_vif.mas_drv_cb.AR_ADDR <= rd_request_channel.AR_ADDR;
					axi_mas_vif.mas_drv_cb.AR_ID   <= rd_request_channel.AR_ID;
					axi_mas_vif.mas_drv_cb.AR_LEN  <= rd_request_channel.AR_LEN;
					axi_mas_vif.mas_drv_cb.AR_SIZE <= rd_request_channel.AR_SIZE;
					axi_mas_vif.mas_drv_cb.AR_BURST<= rd_request_channel.AR_BURST;
					wait(axi_mas_vif.mas_drv_cb.AR_READY);
					//axi_mas_vif.mas_drv_cb.AR_VALID <= 0'b0;
				end
	        end
   endtask
   
   //read_data channel task 
   task read_data();
	   axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) rd_data_channel;
	   forever begin
		@(posedge axi_mas_vif.mas_drv_cb);
	     wait(read_data_channel_q.size() != 0);
		 rd_data_channel = read_data_channel_q.pop_front();
		 for(int i = 0; i<req.burst_len; i++)begin 
		 axi_mas_vif.mas_drv_cb.R_ID <= rd_data_channel.R_ID;
		 axi_mas_vif.mas_drv_cb.R_RESP <= rd_data_channel.R_RESP;
		 axi_mas_vif.mas_drv_cb.R_DATA <= rd_data_channel.R_DATA.pop_front(); 
         wait(axi_mas_vif.mas_drv_cb.RVALID);
	   end
   endtask
 endclass

`endif
   */