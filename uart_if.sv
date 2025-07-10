interface uart_if (clk);
    input bit clk;
    logic reset;
    logic [7:0] P_DATA , P_DATA_OUT , P_DATA_OUT_ex;
    logic PAR_EN;
    logic PAR_TYP;
    logic PAR_OUT , PAR_OUT_ex;
    logic RX_DONE , RX_DONE_ex;
    logic DATA_VALID;
    logic TX_OUT , TX_OUT_ex;
    logic Busy , Busy_ex;

    parameter IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4;

    modport TX ( input clk , reset , P_DATA , PAR_EN , PAR_TYP , DATA_VALID ,
                  output TX_OUT , Busy);

    modport RX (input TX_OUT , clk , reset , Busy , PAR_EN ,
                output P_DATA_OUT , PAR_OUT , RX_DONE );

    modport GM_rx (input TX_OUT , clk , reset , Busy , PAR_EN ,
                output P_DATA_OUT_ex , PAR_OUT_ex , RX_DONE_ex );                
    
    modport GM_tx ( input clk , reset , P_DATA , PAR_EN , PAR_TYP , DATA_VALID ,
                  output TX_OUT_ex , Busy_ex);

    modport TEST ( output  reset , P_DATA , PAR_EN , PAR_TYP , DATA_VALID ,
                   input clk ,TX_OUT , Busy , TX_OUT_ex , Busy_ex , P_DATA_OUT , PAR_OUT , RX_DONE , P_DATA_OUT_ex , PAR_OUT_ex , RX_DONE_ex);
    
    modport MONITOR ( output clk , reset , P_DATA , PAR_EN , PAR_TYP , DATA_VALID , TX_OUT , Busy ,TX_OUT_ex , Busy_ex, P_DATA_OUT , PAR_OUT , RX_DONE);


endinterface 

