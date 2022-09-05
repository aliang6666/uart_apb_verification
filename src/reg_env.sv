import apb_agent_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class reg_env extends uvm_component;
	//成员注册
   reg_agent   i_agt;
   `uvm_component_utils(reg_env)
   uvm_tlm_analysis_fifo#(reg_trans)agt_mdl_fifo;
   
   function new(string name = "reg_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i_agt = reg_agent::type_id::create("i_agt", this);
      i_agt.is_active = UVM_ACTIVE;
      agt_mdl_fifo = new("agt_mdl_fifo", this);
   endfunction

   extern virtual function void connect_phase(uvm_phase phase);
   
   
endclass

//连接TML,并写明输入和输出方向
function void reg_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   i_agt.ap.connect(agt_mdl_fifo.analysis_export);
//   mdl.port.connect(agt_mdl_fifo.blocking_get_export);

endfunction
