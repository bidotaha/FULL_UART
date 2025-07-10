
module uart_golden_model ( uart_if.GOLDEN_MODEL uartif);

parameter IDLE = 0,
          START = 1,
          DATA = 2,
          PARITY = 3,
          STOP = 4;

reg [3:0] state = IDLE;
reg [3:0] counter = 0;
reg [7:0] data_reg;
reg parity_bit;

always @(posedge uartif.clk or negedge uartif.rst_n) begin
  if(!uartif.rst_n) begin
      state <= IDLE;
      uartif.TX_OUT_ex <= 1'b1;
      uartif.busy_ex <= 1'b0;
      counter <= 4'b0000;
end
else begin
  case(state) 
  IDLE: begin
    uartif.TX_OUT_ex <= 1'b1;
    uartif.busy_ex <= 1'b0;
    counter <= 4'b0000;
    if (uartif.DATA_valid) begin
      data_reg <= uartif.P_DATA;
      parity_bit <= (uartif.PAR_TYP) ? ^uartif.P_DATA : ~^uartif.P_DATA;
      state <= START;
      uartif.busy_ex <= 1'b1;
    end
  end
  START: begin
    uartif.TX_OUT_ex <= 1'b0;
    state <= DATA;
    counter <= 4'b0000;
  end
  DATA: begin
    uartif.TX_OUT_ex <= data_reg[counter];
    counter <= counter + 1;
    if (counter == 7) 
        state <= (uartif.PAR_EN) ? PARITY : STOP;
  end
  PARITY: begin
    uartif.TX_OUT_ex <= parity_bit;
    state <= STOP;
  end
  STOP: begin
    uartif.TX_OUT_ex <= 1'b1;
    state <= IDLE;
  end
  endcase
end
end
endmodule 

