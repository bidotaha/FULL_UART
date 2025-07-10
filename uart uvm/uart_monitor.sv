package uart_monitor_pkg;
import uvm_pkg::*;
import uart_seq_item_pkg::*;
`include "uvm_macros.svh"

class uart_monitor extends uvm_monitor;
 `uvm_component_utils (uart_monitor)

virtual uart_if uart_vif;
uart_seq_item rsp_seq_item;
uvm_analysis_port #(uart_seq_item) mon_ap;

  function new (string name = "uart_monitor" , uvm_component parent = null);
    super.new (name,parent);
  endfunction   

 function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  mon_ap = new("mon_ap",this);
 endfunction

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        rsp_seq_item = uart_seq_item::type_id::create ("rsp_seq_item");
        @(negedge uart_vif.clk);
        rsp_seq_item.P_DATA = uart_vif.P_DATA;
        rsp_seq_item.rst_n = uart_vif.rst_n;
        rsp_seq_item.DATA_valid = uart_vif.DATA_valid;
        rsp_seq_item.PAR_EN = uart_vif.PAR_EN;
        rsp_seq_item.PAR_TYP = uart_vif.PAR_TYP;
        rsp_seq_item.TX_OUT = uart_vif.TX_OUT;
        rsp_seq_item.busy = uart_vif.busy;        
        mon_ap.write(rsp_seq_item);
        `uvm_info("run_phase" , rsp_seq_item.convert2string_stimulus(),UVM_HIGH)
    end
  endtask
 endclass
endpackage