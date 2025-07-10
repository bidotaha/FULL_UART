package uart_driver_pkg;
import uvm_pkg::*;
import uart_seq_item_pkg::*;
`include "uvm_macros.svh"

class uart_driver extends uvm_driver#(uart_seq_item);
  `uvm_component_utils (uart_driver) 

  virtual uart_if uart_vif;
  uart_seq_item stim_seq_item;

  function new (string name = "uart_driver" , uvm_component parent = null);
    super.new (name,parent);
  endfunction   

task run_phase (uvm_phase phase);
  super.run_phase(phase);
  forever begin
    stim_seq_item = uart_seq_item::type_id::create("stim_seq_item");
    seq_item_port.get_next_item(stim_seq_item);

    @(negedge uart_vif.clk);
    uart_vif.P_DATA     = stim_seq_item.P_DATA;
    uart_vif.rst_n      = stim_seq_item.rst_n;
    uart_vif.PAR_EN     = stim_seq_item.PAR_EN;
    uart_vif.PAR_TYP    = stim_seq_item.PAR_TYP;
    uart_vif.DATA_valid = 1'b1;
    @(posedge uart_vif.clk); 
    uart_vif.DATA_valid = 1'b0;
    repeat (8) @(posedge uart_vif.clk); 
    seq_item_port.item_done();

    `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
  end
endtask

endclass
endpackage

