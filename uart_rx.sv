module uart_rx (uart_if.RX u_if);

    reg [3:0] counter = 0;
    reg [7:0] DATA_reg;
    reg [3:0] cs = u_if.IDLE;
    reg [3:0] ns = u_if.IDLE;
    
    // State memory
    always @(posedge u_if.clk or negedge u_if.reset) begin
        if (!u_if.reset) begin
            cs <= u_if.IDLE;
        end
        else begin
            cs <= ns;
        end
    end

    // Next state Logic
    always @(*) begin
        case(cs)
            u_if.IDLE: begin
                if (u_if.Busy /*&& u_if.TX_OUT*/ ) begin
                    ns = u_if.START;
                end
            end
            u_if.START: ns = u_if.DATA;
            u_if.DATA: begin
                if (counter == 7) begin
                    ns = (u_if.PAR_EN) ? u_if.PARITY : u_if.STOP;
                end
            end
            u_if.PARITY: ns = u_if.STOP;
            u_if.STOP: ns = u_if.IDLE;
            default: ns = u_if.IDLE;
        endcase
    end

    // Output logic
    always @(posedge u_if.clk or negedge u_if.reset) begin
        if (!u_if.reset) begin
            counter <= 0;
            DATA_reg <= 0;
            u_if.RX_DONE <= 0;
            u_if.PAR_OUT <= 0;

        end
        else begin
            case (cs)
                u_if.IDLE: begin
                    DATA_reg <= 0;
                    counter <= 0;
                    u_if.PAR_OUT <= 0;
                    u_if.RX_DONE <= 0;
                end
                u_if.START: begin
                    counter <= 0;
                end
                u_if.DATA: begin
                    DATA_reg[counter] <= u_if.TX_OUT;
                    counter <= counter + 1;
                end
                u_if.PARITY: begin
                    u_if.PAR_OUT <= u_if.TX_OUT;
                end
                u_if.STOP: begin
                    u_if.P_DATA_OUT <= DATA_reg;
                    u_if.RX_DONE <=1'b1 ;
                end
            endcase
        end
    end
endmodule

