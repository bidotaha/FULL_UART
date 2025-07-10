package uart_conf_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

   class uart_config extends uvm_object;
      `uvm_object_utils(uart_config)

      virtual uart_if uart_vif;
      uvm_active_passive_enum is_active;

      function new (string name = "uart_config");
        super.new(name);
        
      endfunction

   endclass
endpackage