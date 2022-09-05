/***
负责(测试用例的驱动和配置)
1.配置seq
2.驱动seq
***/
import apb_agent_pkg::*;
class apb_test extends base_test;
	//成员注册

   function new(string name = "apb_test", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  uvm_config_db#(uvm_object_wrapper)::set(this,"env.i_agt.sqr","default_sequence",reg_trans::type_id::get());
   endfunction

   extern virtual function void connect_phase(uvm_phase phase);   
   `uvm_component_utils(apb_test)
endclass
