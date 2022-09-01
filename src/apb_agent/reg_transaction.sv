
class reg_trans extends uvm_sequence_item;
//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
	rand bit  [31:0] PADDR	   ;
	rand bit  [31:0] DATA	   ;//读写都用同一个数据
	rand bit  		 PWRITE	   ;//看是读总线0还是写总线1
	rand bit 		 delay	   ;

	constraint delay_bounds {
	  delay inside {[1:20]};
	}
	
	constraint c_cons{
		//合法地址
		soft PADDR[31:7] == 0;//soft PADDR[6:2]
		soft PADDR[1:0] == 0;
		soft PWRITE == `READ -> PADDR[6:2] inside {`DR,`IER,`IIR,`LCR,`MCR,`LSR,`MSR,`DIV1,`DIV2};
		soft PWRITE == `WIRTE -> PADDR[6:2] inside {`DR,`IER,`FCR,`LCR,`MCR,`DIV1,`DIV2};
		//合法写入数据
		soft DATA	[31:8] == 0;//数据有效位8位宽
	}
	// 块注册
	`uvm_object_utils_begin(reg_trans)
		`uvm_field_int(PADDR	, UVM_ALL_ON)
		`uvm_field_int(DATA		, UVM_ALL_ON)
		`uvm_field_int(PWRITE	, UVM_ALL_ON)
	`uvm_object_utils_end
	
	function new(string name = "reg_trans")
		super.new(name);
	endfunction
	
endclass