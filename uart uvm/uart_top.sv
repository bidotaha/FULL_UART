
import uvm_pkg::*;
`include "uvm_macros.svh"
import uart_test_pkg::*;

module uart_top();

  bit clk;

  initial begin
    forever begin
      #1 clk = ~clk;
    end
  end
  
    uart_if uartif (clk);
    uart DUT (uartif);
    uart_golden_model GOLDEN_MODEL (uartif);
    bind uart uart_sva sv (uartif);

  initial begin
    uvm_config_db#(virtual uart_if)::set(null,"uvm_test_top","uart_IF",uartif); 
    run_test("uart_test");
  end

endmodule