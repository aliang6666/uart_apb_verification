/***
负责(不同测试用例中共性的东西)
1.实例化env
2.接收接口数据(接口变成全局变量)

***/
import apb_agent_pkg::*;
class base_test extends uvm_test;
	//成员注册
   reg_env   my_env;

   
   function new(string name = "uvm_base_test", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_env = reg_env::type_id::create("my_env", this);
      //获取module的if,发送给driver
	  if(!uvm_config_db #(virtual aph_intf)::get(this, "my_env.i_agt.drv", "apb_itf", my_env.i_agt.drv.dr_if)) beginy
		`uvm_error("build_phase", "Unable to find APB interface in the uvm_config_db")
	  end
	  /**
	  if(!uvm_config_db #(virtual uart_interrupt)::get(this, "", "u_irq_itf", )) begin
		`uvm_error("build_phase", "Unable to find APB interface in the uvm_config_db")
	  end
	  if(!uvm_config_db #(virtual uart_intf)::get(this, "", "uart_itf", )) begin
		`uvm_error("build_phase", "Unable to find APB interface in the uvm_config_db")
	  end
	  **/
   endfunction

   extern virtual function void connect_phase(uvm_phase phase);   
   `uvm_component_utils(base_test)
endclass

//连接TML,并写明输入和输出方向
function void my_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   i_agt.ap.connect(agt_mdl_fifo.analysis_export);//monitor传出来的
//   mdl.port.connect(agt_mdl_fifo.blocking_get_export);

endfunction
