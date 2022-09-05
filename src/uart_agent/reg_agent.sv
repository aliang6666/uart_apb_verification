
class reg_env extends uvm_env;
	//成员注册
   reg_agent   i_agt;

   
   uvm_tlm_analysis_fifo #(my_transaction) agt_scb_fifo;
   /****
   uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;
   uvm_tlm_analysis_fifo #(my_transaction) mdl_scb_fifo;
   *****/
   
   function new(string name = "reg_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i_agt = my_agent::type_id::create("i_agt", this);
      i_agt.is_active = UVM_ACTIVE;
      agt_scb_fifo = new("agt_scb_fifo", this);
   endfunction

   extern virtual function void connect_phase(uvm_phase phase);
   
   `uvm_component_utils(reg_env)
endclass

//连接TML,并写明输入和输出方向
function void my_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   i_agt.ap.connect(agt_mdl_fifo.analysis_export);
//   mdl.port.connect(agt_mdl_fifo.blocking_get_export);

endfunction
