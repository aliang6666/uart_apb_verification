class uart_seq_item extends uvm_sequence_item;
	//发出数据，需要确认要发的数据值，格式和速率
	`uvm_component_utils(uart_seq_item)
	
	
	//值
	rand bit[7:0] data;//发送的数据
	rand int sbe_clks;
	
	//格式
	rand bit[7:0] lcr;//线控制寄存器，可控制uartd饿发送格式
	
	//接收端的各种错误情况
	rand bit fe;//停止位错误
	rand bit sbe;//起始位错误
	rand bit pe;//校验位错误
	
	//速率
	rand int delay;
	rand bit[15:0] baud_divisor;//调节波特率，读写寄存器
	constraint BR_DIVIDE{
		baud_divisor == 16'h02;//会将时钟分频
	}
	constraint error_dists {
		fe dist {1:= 1, 0:=99};//为1的时候会出现错误
		pe dist {1:= 1, 0:=99};
		sbe dist {1:=1, 0:=50};
	}
	
	constraint clks {
		delay inside {[0:20]};
		sbe_clks inside {[1:4]};
	}
				 
	constraint lcr_setup {lcr == 8'h3f;}//8位数据位，2位停止位，偶校验，数据位为双数奇偶位为1

	function new(string name = "uart_seq_item");
	  super.new(name);
	endfunction
endclass