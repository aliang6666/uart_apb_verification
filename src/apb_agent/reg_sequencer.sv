

class reg_sequencer extends uvm_sequencer#(reg_trans);
	
	`uvm_component_utils(reg_sequencer)

	function new (string name = "reg_sequencer", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
endclass
