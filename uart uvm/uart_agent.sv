package uart_agent_pkg;
import uart_driver_pkg::*;
import uart_monitor_pkg::*;
import uart_sequencer_pkg::*;
import uart_seq_item_pkg::*;
import uart_conf_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  
  
  class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)

    uart_sequencer sqr;
    uart_driver drv;
    uart_monitor mon;
    uart_config uart_cfg;
    uvm_analysis_port #(uart_seq_item) agt_ap;

  function new (string name = "uart_agent" , uvm_component parent = null);
    super.new (name,parent);
  endfunction 

    function void build_phase (uvm_phase phase);
    
    super.build_phase (phase);
     if (!uvm_config_db #(uart_config)::get(this,"","CFG",uart_cfg))
        `uvm_fatal ("build_phase","test - unable to get the configration");

    if (uart_cfg.is_active == UVM_ACTIVE) begin 
    sqr = uart_sequencer::type_id::create ("sqr",this);
    drv = uart_driver::type_id::create ("drv",this);
    end
    mon = uart_monitor::type_id::create ("mon",this);
    agt_ap = new("agt_ap",this);    
  endfunction

  function void connect_phase(uvm_phase phase);
   mon.uart_vif = uart_cfg.uart_vif;
    mon.mon_ap.connect(agt_ap);
   if (uart_cfg.is_active == UVM_ACTIVE) begin 
   drv.uart_vif = uart_cfg.uart_vif;
   drv.seq_item_port.connect(sqr.seq_item_export);
   end 
  endfunction  
  endclass 

endpackage