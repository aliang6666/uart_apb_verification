`include 	param_def.v


class reg_driver extends uvm_driver#(reg_trans);
	
	//接口，因为要驱动
	virtual apb_intf dr_if;
	
	`uvm_component_utils(reg_driver);

	function new(string name = "reg_driver")
		super.new(name);
	endfunction
	
	
	
	
	virtual function build_phase(build_phase phase)
		super.build_phase(phase);
		//连接接口
		if(!uvm_config_db#(virtual apb_if)::get(this, "apb_intf", "dr_if", dr_if))
			 `uvm_fatal("reg_driver", "virtual interface must be set for vif!!!")
	endfunction
	
   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(reg_trans rtr);
   
endclass
/****
先提取trans：1.连接sqr(在agt中实现)  
2.拿取trans  seq_item_port.get_next_item
******/
task my_driver::main_phase(uvm_phase phase);
   dr_if.data <= 8'b0;
   dr_if.valid <= 1'b0;
   while(!dr_if.rst_n)//等待初始化完
      @(posedge dr_if.clk);
   while(1) begin
      seq_item_port.get_next_item(req);//req是自定义的trans
      drive_one_pkt(req);
      seq_item_port.item_done();
   end
endtask

