class reg_sequence extends uvm_sequence #(reg_trans);
   reg_trans m_trans;

   function new(string name= "reg_sequence");
      super.new(name);
   endfunction

   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
	  `uvm_do(m_trans)
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(reg_sequence)
endclass