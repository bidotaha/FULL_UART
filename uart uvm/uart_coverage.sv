package uart_coverage_pkg;
import uart_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  
  
  class uart_coverage extends uvm_component;
    `uvm_component_utils(uart_coverage)

    uvm_analysis_export #(uart_seq_item) cov_export;
    uvm_tlm_analysis_fifo # (uart_seq_item) cov_fifo;
    uart_seq_item seq_item_cov;

        covergroup cvr_gp ;
         label_P_DATA : coverpoint seq_item_cov.P_DATA {
          bins data1 = {8'b00000000};
          bins data2[] = {8'b11111111 , 8'b00000000 , 8'b10101010};}

         label_PAR_TYP : coverpoint seq_item_cov.PAR_TYP;

         label_PAR_EN : coverpoint seq_item_cov.PAR_EN;

         label_DATA_VALID : coverpoint seq_item_cov.DATA_valid;

         label_tx_out : coverpoint seq_item_cov.TX_OUT;

         label_busy : coverpoint seq_item_cov.busy;

         cross_EN_TYP : cross  label_PAR_EN , label_PAR_TYP ;

         cross_DATA_valid : cross label_P_DATA , label_DATA_VALID ;                          

         cross_tx_out_busy : cross label_busy , label_tx_out 
            { ignore_bins bins_0_0 = binsof (label_busy) intersect {0} && 
                                                      binsof (label_tx_out) intersect {0};}          

        endgroup 

  function new (string name = "uart_cov" , uvm_component parent = null);
    super.new (name,parent);
    cvr_gp = new();
  endfunction 

    function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   cov_export.connect(cov_fifo.analysis_export);
  endfunction  

  task run_phase (uvm_phase phase);
   super.run_phase(phase);
   forever begin
    cov_fifo.get(seq_item_cov);
    cvr_gp.sample();
   end
  endtask
  endclass 
  endpackage