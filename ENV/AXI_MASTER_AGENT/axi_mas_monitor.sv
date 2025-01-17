/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_MONITOR
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_MON_SV
`define AXI_MAS_MON_SV

class axi_mas_monitor #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_monitor;
  
  //To identifier index
  int index;
  
  //Factory Registration
  `uvm_component_param_utils_begin(axi_mas_monitor #(ADDR_WIDTH,DATA_WIDTH,SIZE))
		`uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
  `uvm_component_utils_end
  
  //handle of mas_seq_item 
  axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) mas_mon_seq_item_h;
  
  //virtual interface
  virtual axi_mas_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE) axi_mas_vif;
  
  //Analysis Port  
  uvm_analysis_port #(axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)) axi_mon_ap;
  
   //////////////////////////////////////////
   // Name        : CONSTRUCT_NEW
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function new (string name="", uvm_component parent = null);
		super.new(name, parent);
		axi_mon_ap=new("axi_mon_ap",this);
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
   // Name        : MAS_MONITOR_BUILD_PHASE
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  mas_mon_seq_item_h = axi_mas_seq_item#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mas_mon_seq_item_h");
   endfunction
   
   //////////////////////////////////////////
   // Name        : MAS_MONITOR_RUN_PHASE
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   task run_phase(uvm_phase phase);

		//	forever begin
			//	$display("********MASTER MONITOR********");
			//	`uvm_info(get_type_name(),$sformatf("mas_mon_seq_item_h.print %0s",mas_mon_seq_item_h.sprint()),UVM_LOW)
		//	end
		//	write_request();
		//	write_data();
		//	write_response();
		//	read_request();
		//	read_data();
   endtask
     
  /* 
   //////////////////////////////////////////
   // Name        : MAS_MON_WR_REQ_CHANNEL
   // Arguments   : 
   // Discription :
   ///////////////////////////////////////////
   task write_request();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) mon_wr_req_channel;
		$display("this is axi bro");
		mon_wr_req_channel = axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mon_wr_req_channel"); 
		forever begin 
			  wait(axi_mas_vif.mas_mon_cb.AWVALID && axi_mas_vif.mas_mon_cb.AWREADY);
			  for(int i = 0; i<=mas_mon_seq_item_h.AW_LEN-1; i++)begin
				mon_wr_req_channel.AW_ID = axi_mas_vif.mas_mon_cb.AW_ID;
			    mon_wr_req_channel.AW_LEN = axi_mas_vif.mas_mon_cb.AW_LEN;
				mon_wr_req_channel.AW_ADDR = axi_mas_vif.mas_mon_cb.AW_ADDR;//TODO USING PUSH_BACK
				mon_wr_req_channel.AW_BURST = axi_mas_vif.mas_mon_cb.AW_BURST;
				mon_wr_req_channel.AW_SIZE = axi_mas_vif.mas_mon_cb.AW_SIZE; 
				axi_mon_ap.write(mon_wr_req_channel);
				mon_wr_req_channel.print();
				$display("write request master");
			end
		end 
   endtask 
  
   //////////////////////////////////////////
   // Name        : MAS_MON_WR_DATA_CHANNEL
   // Arguments   : 
   // Discription :
   ///////////////////////////////////////////
   task write_data();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) mon_wr_data_channel;
		mon_wr_data_channel = axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mon_wr_data_channel"); 
		forever begin
			  wait(axi_mas_vif.mas_mon_cb.WVALID && axi_mas_vif.mas_mon_cb.WREADY);
			  for(int i = 0; i<=mas_mon_seq_item_h.AW_LEN-1; i++)begin
				mon_wr_data_channel.W_ID = axi_mas_vif.mas_mon_cb.W_ID;
			    mon_wr_data_channel.W_DATA.push_back(axi_mas_vif.mas_mon_cb.W_DATA);
				mon_wr_data_channel.W_LAST = axi_mas_vif.mas_mon_cb.W_LAST;
				//axi_mon_ap.write(mon_wr_data_channel);
				mon_wr_data_channel.print();
				$display("write data master");
			end
		end 
   endtask
   
   //////////////////////////////////////////
   // Name        : MAS_MON_WR_RSP_CHANNEL
   // Arguments   : 
   // Discription :
   ///////////////////////////////////////////
   task write_response();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) mon_wr_rsp_channel;
		mon_wr_rsp_channel = axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mon_wr_rsp_channel"); 
		forever begin 
		   wait(axi_mas_vif.mas_mon_cb.BVALID && axi_mas_vif.mas_mon_cb.BREADY);
   		   for(int i = 0; i<=mas_mon_seq_item_h.AW_LEN-1; i++)begin
		   mon_wr_rsp_channel.B_ID = axi_mas_vif.mas_mon_cb.B_ID;
		   mon_wr_rsp_channel.B_RESP = axi_mas_vif.mas_mon_cb.B_RESP;
		   axi_mon_ap.write(mon_wr_rsp_channel);
		   mon_wr_rsp_channel.print();
		   $display("write response master");
		   end
		end 
   endtask 
   
   //////////////////////////////////////////
   // Name        : MAS_MON_RD_REQ_CHANNEL
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   task read_request();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) mon_rd_req_channel;
		 $display("this is read_request");
		mon_rd_req_channel = axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mon_rd_req_channel"); 
		/*forever begin
		   wait(axi_mas_vif.mas_mon_cb.AR_VALID && axi_mas_vif.mas_mon_cb.AR_READY);
		   for(int i = 0; i<=mas_mon_seq_item_h.AW_LEN-1; i++)begin
		   mon_rd_req_channel.AR_ID = axi_mas_vif.mas_mon_cb.AR_ID;
		   mon_rd_req_channel.AR_ADDR = axi_mas_vif.mas_mon_cb.AR_ADDR.pop_front();//TODO USING PUSH_BACK
		   mon_rd_req_channel.AR_LEN = axi_mas_vif.mas_mon_cb.AR_LEN;
		   mon_rd_req_channel.AR_SIZE = axi_mas_vif.mas_mon_cb.AR_SIZE;
		   mon_rd_req_channel.AR_BURST = axi_mas_vif.mas_mon_cb.AR_BURST;
		  // axi_mon_ap.write(mon_rd_req_channel);
		   mon_rd_req_channel.print();
		   $display("read request master");
		   end
		end 
   endtask 
  
   //////////////////////////////////////////
   // Name        : MAS_MON_RD_DATA_CHANNEL
   // Arguments   : 
   // Discription :
   ///////////////////////////////////////////
   task read_data();
		axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) mon_rd_data_channel;
		mon_rd_data_channel = axi_mas_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create("mon_rd_data_channel"); 
		forever begin 
		   wait(axi_mas_vif.mas_mon_cb.AR_VALID && axi_mas_vif.mas_mon_cb.AR_READY);
		   for(int i = 0; i<=mas_mon_seq_item_h.AW_LEN-1; i++)begin
		   mon_rd_data_channel.R_ID = axi_mas_vif.mas_mon_cb.R_ID;
		   mon_rd_data_channel.R_DATA = axi_mas_vif.mas_mon_cb.R_DATA.pop_front();
		   mon_rd_data_channel.R_RESP = axi_mas_vif.mas_mon_cb.R_RESP;
		   mon_rd_data_channel.R_LAST = axi_mas_vif.mas_mon_cb.R_LAST;
		   axi_mon_ap.write(mon_rd_data_channel);
		   mon_rd_data_channel.print();
		   $display("read_data master");
		   end
		end
   endtask*/
   
endclass

`endif