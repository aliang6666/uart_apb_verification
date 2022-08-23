`include 	param_def.v


class reg_driver extends uvm_driver#(reg_trans);
	
	//设置接口，因为要驱动
	virtual apb_intf dr_if;
	
	`uvm_component_utils(reg_driver);

	function new(string name = "reg_driver")
		super.new(name);
	endfunction
	
	virtual function build_phase(build_phase phase)
		super.build_phase(phase);
		//连接到接口
		if(!uvm_config_db#(virtual apb_intf)::get(this, "apb_intf", "dr_if", dr_if))
			 `uvm_fatal("reg_driver", "virtual interface must be set for vif!!!")
	endfunction
	
   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(reg_trans rtr);
   
endclass
/****
先提取trans：1.连接sqr(在agt中实现)  
2.拿取trans  seq_item_port.get_next_item
驱动总线
******/
task my_driver::main_phase(uvm_phase phase);
	//初始化输出端口
   dr_if.PADDR <= 32'b0;
   dr_if.PWDATA <= 32'b0;
   while(!dr_if.rst_n)//等待初始化完
      @(posedge dr_if.PCLK);
   forever begin
      seq_item_port.get_next_item(req);//req是自定义的trans
      drive_one_pkt(req);//驱动一个trans
      seq_item_port.item_done();//告知seq驱动完
   end
endtask

//驱动一个trans
task drive_one_pkt(reg_trans rtr);
	//每次传输都要进入初始状态
    dr_if.PSEL <= 0;
    dr_if.PENABLE <= 0;
    dr_if.PRDATA <= 0;
	case(rtr.PWRITE)//读写功能选择
		`WRITE: begin 
				  @(posedge dr_if.PCLK);
				  dr_if.PWRITE <= rtr.PWRITE;	//读写命令
				  dr_if.PSEL <= rtr.PSEL;		//片选使能
				  dr_if.PADDR <= rtr.PADDR;		//写的地址
				  dr_if.PWDATA <= rtr.PWDATA;	//写的数据			  
				  @(posedge dr_if.PCLK);
				  dr_if.PENABLE <= 1;			//第二个时钟使能
				  while (!dr_if.PREADY)//等待总线slave应答，应答ok为1
					@(posedge dr_if.PCLK);
				  @(posedge dr_if.PCLK);//等待下一个周期才结束
				end
		`READ:  begin 
				  @(posedge dr_if.PCLK);
				  dr_if.PWRITE <= rtr.PWRITE;
				  dr_if.PSEL <= 1;
				  dr_if.PADDR <= rtr.PADDR;
				  @(posedge dr_if.PCLK);
					dr_if.PENABLE <= 1;
				  while (!dr_if.PREADY)//等待总线slave应答，应答ok为1
					@(posedge dr_if.PCLK);
				  rtr.PRDATA <= dr_if.PRDATA;//有应答则在这个时钟下读取数据
				  @(posedge dr_if.PCLK);
				end
		default: $error("command %b is illegal", rtr.PWRITE);
	endcase
	
endtask

