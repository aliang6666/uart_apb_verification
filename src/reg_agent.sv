
class reg_agent extends uvm_agent;
	//组件成员
   reg_sequencer  sqr;
   reg_driver     drv;
   reg_monitor    mon;
   //从monitor中传trans
   uvm_analysis_port #(reg_trans) ap;
   
	`uvm_component_uitls(reg_agent)
	
	function new(string new = "reg_agent");
		super.new(name);
	endfunction
	

	extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

	//组件的实例化
	function void reg_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (is_active == UVM_ACTIVE) begin
			sqr = reg_sequencer::type_id::create("sqr", this);
			drv = reg_monitor::type_id::create("drv", this);
	    end
	    mon = reg_monitor::type_id::create("mon", this);
		ap = new("ap", this);//发送给monitor的tlm
	endfunction
	
	//使用的连接，包括sqr和dr的连接，还有把monitor的接口连接出来
	function void reg_agent::connect_phase(uvm_phase phase);
	   super.connect_phase(phase);
	   if (is_active == UVM_ACTIVE) begin
		  drv.seq_item_port.connect(sqr.seq_item_export);//连接sqr和driver
	   end
	   //ap = mon.ap;//直接的把tlm机制中的，mon和agent连接
		mon.ap.connect(ap);//把monitor打包的tlm连接到agent层
	endfunction