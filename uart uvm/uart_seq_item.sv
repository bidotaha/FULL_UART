package uart_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
parameter IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4;
class uart_seq_item extends uvm_sequence_item;
  `uvm_object_utils(uart_seq_item)
    rand logic rst_n;
    rand logic [7:0] P_DATA;
    rand logic PAR_EN;
    rand logic PAR_TYP;
    rand logic DATA_valid;
    rand logic direction,cin;
    logic TX_OUT;
    logic TX_OUT_ex;
    logic busy;
    logic busy_ex;
    bit clk;
    bit [7:0] vals [] = '{8'b11111111 , 8'b00000000 , 8'b10101010};
    bit [7:0] P_DATA_vals;      

  function new (string name = "uart_seq_item");
    super.new (name);
  endfunction  
  function string convert2string();
      return $sformatf("%s rst_n=%b P_DATA=%b TX_OUT=%b busy=%b",super.convert2string(),rst_n,P_DATA,TX_OUT,busy);
  endfunction    
  function string convert2string_stimulus();
      return $sformatf(" rst_n=%b P_DATA=%b TX_OUT=%b busy=%b",rst_n,P_DATA,TX_OUT,busy);
  endfunction  
        constraint rst_cns{
            rst_n dist{0:= 3 ,1:= 97};
        }
        constraint PAR_TYP_cns{
            PAR_TYP dist{0:= 50 ,1:= 50};
        }
        constraint PAR_EN_cns{
            PAR_EN dist{0:= 75 ,1:= 25};
        }
        constraint DATA_valid_cns{
            DATA_valid dist{0:= 5 ,1:= 95};
        }
        constraint P_DATA_cns {         
             P_DATA_vals inside {vals};
             P_DATA dist {
                8'b00001111 := 50, 
                P_DATA_vals := 4,
                [1:255] := 50};
        }
endclass
endpackage