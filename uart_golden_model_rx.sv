module uart_golden_model_rx (uart_if.GM_rx u_if);

    reg [2:0] state = u_if.IDLE;
    reg [3:0] counter = 0;
    reg [7:0] DATA_reg;

always @(posedge u_if.clk or negedge u_if.reset) begin
    if (!u_if.reset) begin
        state <= u_if.IDLE;
        u_if.PAR_OUT_ex <= 0;
        u_if.RX_DONE_ex <= 0;
        counter <= 0;
        DATA_reg <= 0;
    end else begin
        case (state)
          u_if.IDLE: begin
                DATA_reg <= 0;
                counter <= 0;
                u_if.PAR_OUT_ex <= 0;
                u_if.RX_DONE_ex <= 0;
                if (u_if.Busy) begin
                    state <= u_if.START;
                end
          end
          u_if.START: begin
                state <= u_if.DATA;
                counter <= 0;
          end
          u_if.DATA: begin
                    DATA_reg[counter] <= u_if.TX_OUT;
                    counter <= counter + 1;
                if (counter == 7) begin
                    state = (u_if.PAR_EN) ? u_if.PARITY : u_if.STOP;
                end
          end
          u_if.PARITY: begin
                    u_if.PAR_OUT_ex <= u_if.TX_OUT;
                    state <= u_if.STOP;
          end
          u_if.STOP: begin
                    u_if.P_DATA_OUT_ex <= DATA_reg;
                    u_if.RX_DONE_ex <=1'b1 ;
                    state <= u_if.IDLE;
          end
        endcase
        end
end
endmodule