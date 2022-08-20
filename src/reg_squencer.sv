

class reg_squencer extends uvm_squencer#(reg_trans);
	
	`uvm_component_uitls(reg_squencer)

	function new (string name = "reg_squencer")
		super.new(name);
	endfunction
	
endclass
