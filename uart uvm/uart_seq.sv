package uart_seq_pkg;
import uvm_pkg::*;
import uart_seq_item_pkg::*;
`include "uvm_macros.svh"

class uart_reset_seq extends uvm_sequence #(uart_seq_item);
  `uvm_object_utils(uart_reset_seq)
   uart_seq_item seq_item;

    function new(string name = "uart_reset_seq");
        super.new(name);
    endfunction 

    task body;
       seq_item = uart_seq_item::type_id::create("seq_item");
       start_item(seq_item);
       seq_item.rst_n = 0;
       finish_item (seq_item);
    endtask
endclass 

class uart_main_seq extends uvm_sequence #(uart_seq_item);
  `uvm_object_utils(uart_main_seq)
   uart_seq_item seq_item;

    function new(string name = "uart_main_seq");
        super.new(name);
    endfunction 

    task body;
       seq_item = uart_seq_item::type_id::create("seq_item");
       repeat (9999) begin 
       start_item(seq_item);     
       assert (seq_item.randomize());
       finish_item (seq_item);
       end
    endtask
endclass 

endpackage