/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_SLV_MONITOR
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_SLV_MONITOR_SV
`define AXI_SLV_MONITOR_SV

class axi_slv_monitor #(int ADDR_WIDTH = 32, DATA_WIDTH = 32, SIZE = 3) extends uvm_monitor;
  //to indentify driver
  int index;
  int i= 0;
  //Factory Registration-----
  `uvm_component_param_utils_begin(axi_slv_monitor #(ADDR_WIDTH,DATA_WIDTH,SIZE))
		`uvm_field_int(index, UVM_ALL_ON| UVM_DEC)
  `uvm_component_utils_end
      
   //global instance declaration for wr/rd channels
   axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) wr_slv_mon[int];
   axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE) rd_slv_mon[int];
      
   //virtual interface
   virtual axi_slv_inf #(ADDR_WIDTH,DATA_WIDTH,SIZE) axi_slv_vif;
   
   //write_ana_port
   uvm_analysis_port #(axi_slv_seq_item #(ADDR_WIDTH, DATA_WIDTH, SIZE)) item_req_wport;
   
   //read_ana_port
   uvm_analysis_port #(axi_slv_seq_item #(ADDR_WIDTH, DATA_WIDTH, SIZE)) item_req_rport;

   //memory declaration 
   //memory declaration 
   bit [(DATA_WIDTH - 1) : 0] axi_mem [bit[0 : (ADDR_WIDTH - 1) ]];
  
   /////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   function new (string name="", uvm_component parent = null);
     super.new(name, parent);
	 item_req_wport=new("item_req_wport",this); 	 		
	 item_req_rport=new("item_req_rport",this); 	 		
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
		$display("*******************SLV_MONITOR************************");
	/* if(wr_slv_mon.exists[axi_slv_vif.slv_mon_cb.AW_LEN])begin 
		  foreach(wr_slv_mon[i])begin 
		     wr_slv_mon[i] = axi_slv_seq_item#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("wr_slv_mon[%0d]",i));
	       end
	 foreach(rd_slv_mon[i])begin
		  rd_slv_mon[i] = axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("rd_slv_mon[%0d]",i));
	 end*/
  endfunction
   
   //////////////////////////////////////////
   // Name        :
   // Arguments   :
   // Discription :
   ///////////////////////////////////////////
   task run_phase(uvm_phase phase);
	    fork
			dut_to_mon(); 
	    join
   endtask 
  ///////////////////////////////////////////////////////////////////  
  task dut_to_mon();
		fork 
			monitor_write_request();
			monitor_write_data();
			monitor_write_response();
			monitor_read_request();
			monitor_read_data();
		join
   endtask 
  ///////////////////////////////////////////////////////////////////
  //write_request/address channel task 
  task monitor_write_request();
	  @(posedge axi_slv_vif.slv_mon_cb);
	     forever begin
				@(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.AWVALID);
            	@(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.WVALID);
				@(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.AWREADY);
				if(wr_slv_mon.exists(axi_slv_vif.slv_mon_cb.AW_ID))begin
//create che ke nai te check karva mate exits method levi pade id exists hoy toh create ==========				
                wr_slv_mon[i] = axi_slv_seq_item#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("wr_slv_mon[%0d]",i));
				wr_slv_mon[i].AW_ID = axi_slv_vif.slv_mon_cb.AW_ID;
				wr_slv_mon[i].AW_BURST = axi_slv_vif.slv_mon_cb.AW_BURST;
				wr_slv_mon[i].AW_SIZE = axi_slv_vif.slv_mon_cb.AW_SIZE;
				wr_slv_mon[i].AW_LEN = axi_slv_vif.slv_mon_cb.AW_LEN;
				wr_slv_mon[i].AW_ADDR_q.push_back(axi_slv_vif.slv_mon_cb.AW_ADDR_q);
				item_req_wport.write(wr_slv_mon[i]);
				$display("write_request slv1");
				i++;
				end
	        end
   endtask

   //write_data channel task 
   task monitor_write_data();
		 @(posedge axi_slv_vif.slv_mon_cb);
		 forever begin
					@(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.AWVALID);
            	    @(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.WVALID);
				   if(wr_slv_mon.exists(axi_slv_vif.slv_mon_cb.W_ID))begin 
				    wr_slv_mon[i] = axi_slv_seq_item#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("wr_slv_mon[%0d]",i));
					wr_slv_mon[i].W_ID = axi_slv_vif.slv_mon_cb.W_ID;
					wr_slv_mon[i].W_DATA.push_back(axi_slv_vif.slv_mon_cb.W_DATA);	
					axi_mem[wr_slv_mon[i].AW_ADDR_q[i]] = axi_slv_vif.slv_mon_cb.W_DATA;
					$display("write_data is [%0p]",wr_slv_mon[i].W_DATA);
					wr_slv_mon[i].W_STRB.push_back(axi_slv_vif.slv_mon_cb.W_STRB);
				 	wr_slv_mon[i].W_LAST = axi_slv_vif.slv_mon_cb.W_LAST;
					item_req_wport.write(wr_slv_mon[i]);
					$display("write_data slv");
					i++;
				 end
		  end
   endtask
 
   //write_response channel task 
   task monitor_write_response();
		@(posedge axi_slv_vif.slv_mon_cb);
		forever begin
			@(posedge axi_slv_vif.slv_mon_cb iff  axi_slv_vif.slv_mon_cb.BVALID);
			@(posedge axi_slv_vif.slv_mon_cb iff  axi_slv_vif.slv_mon_cb.BREADY);
		  	if(wr_slv_mon.exists(axi_slv_vif.slv_mon_cb.B_ID))begin 
				wr_slv_mon[i] = axi_slv_seq_item#(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("wr_slv_mon[%0d]",i));
				wr_slv_mon[i].B_ID = axi_slv_vif.slv_mon_cb.B_ID;
				wr_slv_mon[i].B_RESP = axi_slv_vif.slv_mon_cb.B_RESP; 
				item_req_wport.write(wr_slv_mon[i]);
				wr_slv_mon[i].print(); //FOR ALL THREE WR_CHANNELS PRINT..
				$display("write_response slv");
			end
		end
   endtask
   
   //read_request channel task 
   task monitor_read_request();
		@(posedge axi_slv_vif.slv_mon_cb);
		forever begin
			 @(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.AR_VALID);
		     @(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.AR_READY);
  		     if(rd_slv_mon.exists(axi_slv_vif.slv_mon_cb.AR_ID))begin 
				 rd_slv_mon[i] = axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("rd_slv_mon[%0d]",i));
				 rd_slv_mon[i].AR_ID = axi_slv_vif.slv_mon_cb.AR_ID;
				 rd_slv_mon[i].AR_ADDR_q.push_back(axi_slv_vif.slv_mon_cb.AR_ADDR_q);
				 rd_slv_mon[i].AR_LEN = axi_slv_vif.slv_mon_cb.AR_LEN;
				 rd_slv_mon[i].AR_SIZE = axi_slv_vif.slv_mon_cb.AR_SIZE;
				 rd_slv_mon[i].AR_BURST = axi_slv_vif.slv_mon_cb.AR_BURST;
				 item_req_rport.write(rd_slv_mon[i]);//TODO-----------
				 $display("read_request slv1");
			 end
		end
   endtask
  //read_request channel task 
   task monitor_read_data();
		@(posedge axi_slv_vif.slv_mon_cb);
		forever begin
			@(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.RVALID);
			@(posedge axi_slv_vif.slv_mon_cb iff axi_slv_vif.slv_mon_cb.RREADY);
		    if(rd_slv_mon.exists(axi_slv_vif.slv_mon_cb.R_ID))begin
				rd_slv_mon[i] = axi_slv_seq_item #(ADDR_WIDTH,DATA_WIDTH,SIZE)::type_id::create($sformatf("rd_slv_mon[%0d]",i));		
				rd_slv_mon[i].R_ID = axi_slv_vif.slv_mon_cb.R_ID;
				rd_slv_mon[i].R_DATA.push_back(axi_mem[rd_slv_mon[i].AR_ADDR_q[i]]);
				`uvm_info(get_type_name(),$sformatf("memory for slv_read_data is %0p",axi_slv_vif.slv_drv_cb.R_DATA),UVM_LOW)
				rd_slv_mon[i].R_RESP = axi_slv_vif.slv_mon_cb.R_RESP;
				rd_slv_mon[i].R_LAST = axi_slv_vif.slv_mon_cb.R_LAST;
				item_req_rport.write(rd_slv_mon[i]);//TODO
				rd_slv_mon[i].print();//FOR ALL TWO READ CHANNELS PRINT....
				$display("read_data slv");
			end
		end
   endtask
 endclass

`endif