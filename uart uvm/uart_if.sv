interface uart_if (clk);
    input bit clk;
    logic rst_n, PAR_EN, PAR_TYP, DATA_valid, TX_OUT, TX_OUT_ex, busy, busy_ex;
    logic [7:0] P_DATA;

    modport DUT (
    input clk, rst_n, PAR_EN, PAR_TYP, DATA_valid, P_DATA,
    output TX_OUT, busy 
    );

    modport GOLDEN_MODEL (
    input clk, rst_n, PAR_EN, PAR_TYP, DATA_valid, P_DATA,
    output TX_OUT_ex, busy_ex 
    );


endinterface 