
package uart_env_pkg;
import uart_agent_pkg::*;
import uart_sco_pkg::*;
import uart_coverage_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class uart_env extends uvm_env;
  `uvm_component_utils (uart_env)  

uart_agent agt;
uart_sco sb;
uart_coverage cov;
   
  function new (string name = "uart_env" , uvm_component parent = null);
    super.new (name,parent);
  endfunction 

  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    agt = uart_agent::type_id::create ("agt",this);
    sb = uart_sco::type_id::create ("sb",this);
    cov = uart_coverage::type_id::create ("cov",this);
  endfunction

  function void connect_phase (uvm_phase phase);
   agt.agt_ap.connect(sb.sb_export);
   agt.agt_ap.connect(cov.cov_export);
  endfunction

endclass
endpackage