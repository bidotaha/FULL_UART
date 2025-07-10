module uart_top ;
  bit clk ;
  initial begin
    forever #1 clk = ~clk ;
  end

  uart_if u_if (clk) ;
  uart_tb tb (u_if) ;
  uart_tx TX (u_if) ;
  uart_rx RX (u_if) ;
  //uart_monitor MON (u_if) ;
  uart_golden_model_tx GM_tx (u_if) ;
  uart_golden_model_rx GM_rx (u_if) ; 

  bind uart_tx uart_sva_tx svatx (u_if) ;
  bind uart_rx uart_sva_rx svarx (u_if) ;

  endmodule 