

class reg_sequencer extends uvm_sequencer#(reg_trans);
	
	`uvm_component_uitls(reg_sequencer)

	function new (string name = "reg_sequencer")
		super.new(name);
	endfunction
	
endclass
