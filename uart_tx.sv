module uart_tx (uart_if.TX u_if);

    reg [2:0] state = u_if.IDLE;
    reg [3:0] counter = 0;
    reg [7:0] DATA_reg;
    reg  PARITY_bit;
always @(posedge u_if.clk or negedge u_if.reset) begin
    if (!u_if.reset) begin
        state <= u_if.IDLE;
        u_if.TX_OUT <= 1'b1;
        u_if.Busy <= 1'b0;
        counter <= 0;
    end else begin
        case (state)
          u_if.IDLE: begin
                u_if.TX_OUT <= 1'b1;
                u_if.Busy <= 1'b0;
                counter <= 0;
                if (u_if.DATA_VALID) begin
                    DATA_reg <= u_if.P_DATA;
                    PARITY_bit <= (u_if.PAR_TYP == 0) ? ~^u_if.P_DATA : ^u_if.P_DATA;
                    state <= u_if.START;
                    u_if.Busy <= 1'b1;
                end
          end
          u_if.START: begin
                u_if.TX_OUT <= 1'b0;
                state <= u_if.DATA;
                counter <= 0;
          end
          u_if.DATA: begin
                  u_if.TX_OUT <= DATA_reg[counter];
                  counter <= counter + 1;
                  if (counter == 7)
                  state <= (u_if.PAR_EN) ? u_if.PARITY : u_if.STOP;
          end
          u_if.PARITY: begin
                    u_if.TX_OUT <= PARITY_bit;
                    state <= u_if.STOP;
          end
          u_if.STOP: begin
                  u_if.TX_OUT <= 1'b1;
                  state <= u_if.IDLE;
          end
        endcase
        end
end
endmodule