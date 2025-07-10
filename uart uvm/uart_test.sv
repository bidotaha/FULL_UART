
package uart_test_pkg;
import uart_env_pkg::*;
import uart_conf_pkg::*;
import uart_seq_pkg::*;
import uvm_pkg::*;
import uart_seq_item_pkg::*;
`include "uvm_macros.svh"

class uart_test extends uvm_test;

  `uvm_component_utils (uart_test) 

  uart_env env;
  uart_config uart_cfg;
  virtual uart_if uart_vif;
  uart_main_seq main_seq;
  uart_reset_seq reset_seq;

  function new (string name = "uart_env" , uvm_component parent = null);
    super.new (name,parent);
  endfunction   

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = uart_env::type_id::create ("env",this);
    uart_cfg = uart_config::type_id::create ("uart_cfg");
    main_seq = uart_main_seq::type_id::create("main_seq");
    reset_seq = uart_reset_seq::type_id::create("reset_seq");

    uart_cfg.is_active = UVM_ACTIVE;

    if (!uvm_config_db#(virtual uart_if)::get(this,"","uart_IF",uart_cfg.uart_vif))
       `uvm_fatal ("build_phase","test - unable to get the virtual interface");

       uvm_config_db#(uart_config)::set(this,"*","CFG",uart_cfg); 
  
  endfunction

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    //reset
    `uvm_info ("run_phase" , "reset asserted" , UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info ("run_phase" , "reset deasserted" , UVM_LOW)
    
    //main
    `uvm_info ("run_phase" , "stimulus generation started 1" , UVM_LOW)
    main_seq.start(env.agt.sqr);
    `uvm_info ("run_phase" , "stimulus generation ended 1" , UVM_LOW)         

    //reset
    `uvm_info ("run_phase" , "reset asserted" , UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info ("run_phase" , "reset deasserted" , UVM_LOW)     

    phase.drop_objection(this);
  endtask

endclass: uart_test
endpackage