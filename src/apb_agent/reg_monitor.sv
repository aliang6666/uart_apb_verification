
class reg_monitor extends uvm_component;
	//组件成员
	virtual apb_intf vif;//连接接口
	//从monitor中传trans出去给scoreboard
	uvm_analysis_port #(reg_trans) ap;
	
	`uvm_component_utils(reg_monitor);
	
	function new(string name = "reg_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
	extern task collect_one_pkt(reg_trans tr);
endclass

	//组件的实例化并且接收接口数据
	function void reg_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		//获取来自接口数据
	    if(!uvm_config_db#(virtual apb_intf)::get(this, "", "vif", vif))
			`uvm_fatal("my_monitor", "virtual interface must be set for vif!!!")
	    ap = new("ap", this);//实例化
	endfunction
	
	task reg_monitor::main_phase(uvm_phase phase);
	   reg_trans tr;
	   while(1) begin
		  tr = new("tr");
		  collect_one_pkt(tr);
		  ap.write(tr);//把接口的trans，写到ap中
	   end
	endtask
	
	//只在数据有效，并且被选通的时候，采样
	task reg_monitor::collect_one_pkt(reg_trans tr);
		@(posedge vif.PCLK);
		if(vif.PREADY && vif.PSEL) begin
			tr.PADDR = vif.PADDR;
			tr.PWRITE = vif.PWRITE;
			if(vif.PWRITE)begin
				tr.DATA = vif.PWDATA;
			end
			else begin
				tr.DATA = vif.PRDATA;
			end	
		end
	endtask