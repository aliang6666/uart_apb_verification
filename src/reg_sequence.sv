class reg_sequence extends uvm_sequence #(reg_trans);
   reg_transaction m_trans;

   function new(string name= "reg_sequence");
      super.new(name);
   endfunction

   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat ($urandom_range(10,100)) begin//启动之后，随机10-100次
         `uvm_do(m_trans)
      end
      #1000;
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(reg_sequence)
endclass