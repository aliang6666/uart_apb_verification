class uart_driver extends uart_driver #(uart_seq_item);
	
	`uvm_component_utils(uart_driver)
	virtual uart_interface uart_if;
	uart_seq_item pkt;//接收到的seq_item
	
	function new(string name = "uart_driver", uvm_component parent = null);
	  super.new(name, parent);
	endfunction

	extern function build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task drive_one_pkt(reg_trans rtr);
endclass

	function uart_driver::build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual uart_interface)::set(this,"","uart_if",uart_if))
			 `uvm_fatal("uart_driver", "virtual interface must be set for vif!!!")
	endfunction
	
	task uart_driver::main_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(pkt);
			drive_one_pkt(pkt);
		end
	endtask: main_phase


	task uart_driver::drive_one_pkt(reg_trans rtr);
		@posedge uart_if.clk;
		uart_if.rx <= 0;//开始位
		@posedge uart_if.clk;
		//先发前5位数据
		for(int i=0;i<5;i++)begin
			uart_if.rx <= rtr.data[i];
			@posedge uart_if.clk;
		end
		
		//后几位数据看情况
		if(rtr.lcr[0]==1)
			uart_if.rx <= rtr.data[5];
		@posedge uart_if.clk;
		if(rtr.lcr[1]==1)
			uart_if.rx <= rtr.data[6];
		@posedge uart_if.clk;
		if(rtr.lcr[1:0]>2)
			uart_if.rx <= rtr.data[7];
		@posedge uart_if.clk;	
		//停止位
		if(rtr.lcr[2]==0)begin 
			uart_if.rx <= 1;
			@posedge uart_if.clk;
		end
		else if(rtr.lcr[1:0]>=1&&rtr.lcr[2]==1)begin			
			uart_if.rx <= 1;
			@posedge uart_if.clk;
			@posedge uart_if.clk;			
		end
		else
			uart_if.rx <= 1;
			@posedge uart_if.clk;
	endtask:drive_one_pkt
	
	




class uart_driver extends uvm_driver #(uart_seq_item, uart_seq_item);

`uvm_component_utils(uart_driver)

function new(string name = "uart_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

virtual uart_interface uart_if;

uart_seq_item pkt;

bit clk;
logic[15:0] divisor;

task send_pkts;
// Receives a character according to the appropriate word format
  integer bitPtr = 0;
  begin
    sline.sdata = 1;//初始化数据
    forever
      begin
        seq_item_port.get_next_item(pkt);
        divisor = pkt.baud_divisor;
        // Variable delay
        repeat(pkt.delay)
          @(posedge sline.clk);
        if (pkt.sbe)
          begin
            sline.sdata = 0;
            repeat(pkt.sbe_clks)
              @(posedge sline.clk);
            sline.sdata = 1;
            repeat(pkt.sbe_clks)
              @(posedge sline.clk);
          end
        // Start bit
        sline.sdata = 0;
        bitPtr = 0;//比特发送位数
        bitPeriod;//波特率延时
        // Data bits 0 to 4
        while(bitPtr < 5)
          begin
            sline.sdata = pkt.data[bitPtr];
            bitPeriod;
            bitPtr++;
          end
        // Data bits 5 to 7
        if (pkt.lcr[1:0] > 2'b00)//他定义了不同的长度
          begin
            sline.sdata = pkt.data[5];
            bitPeriod;
          end
        if (pkt.lcr[1:0] > 2'b01)
          begin
            sline.sdata = pkt.data[6];
            bitPeriod;
          end
        if (pkt.lcr[1:0] > 2'b10)
          begin
            sline.sdata = pkt.data[7];
            bitPeriod;
          end
        // Parity
        if (pkt.lcr[3])
          begin
            sline.sdata = logic'(calParity(pkt.lcr, pkt.data));
            if (pkt.pe)
              sline.sdata = ~sline.sdata;
            bitPeriod;
          end
        // Stop bit
        if (!pkt.fe)
          sline.sdata = 1;
        else
          sline.sdata = 0;
        bitPeriod;
        if (!pkt.fe)
          begin
            if (pkt.lcr[2])
              begin
                if (pkt.lcr[1:0] == 2'b00)
                  begin
                    repeat(8)
                      @(posedge sline.clk);
                  end
                else
                  bitPeriod;
              end
          end
        else
          begin
            sline.sdata = 1;
            bitPeriod;
          end
        seq_item_port.item_done();
      end
  end
endtask: send_pkts

task bitPeriod;
  begin
    repeat(16)
      @(posedge sline.clk);
  end
endtask: bitPeriod

task run_phase(uvm_phase phase);
    send_pkts;
endtask: run_phase


endclass: uart_driver
