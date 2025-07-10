
module uart_sva ( uart_if.DUT uartif );

    parameter IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4;

    property reset_check;
        @(posedge uartif.clk) (!uartif.rst_n) |=> 
         (uart.state==IDLE && uartif.TX_OUT==1'b1 && uartif.busy==1'b0 && uart.counter==8'b00000000);
    endproperty
    assert property (reset_check) else $error(" error in rst ");
    cover property (reset_check);

    property check1;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==IDLE) 
         |=> (uartif.TX_OUT==1 && uartif.busy==0 && uart.counter==0);
    endproperty
    assert property (check2) else $error("error in check2");
    cover property (check2);    

    property check2;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==IDLE && uartif.DATA_valid) 
         |=> (uart.data_reg==$past(uartif.P_DATA));
    endproperty
    assert property (check2) else $error("error in check2");
    cover property (check2);    

    property check3;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==IDLE && uartif.DATA_valid) 
         |=> (uart.state==START && uartif.busy==1'b1);
    endproperty
    assert property (check3) else $error("error in check3");
    cover property (check3);    

    property check4;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==IDLE && uartif.DATA_valid && uartif.PAR_TYP) 
         |=> (uart.parity_bit == ^$past(uartif.P_DATA));
    endproperty
    assert property (check4) else $error("error in check4");
    cover property (check4);   

    property check5;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==IDLE && uartif.DATA_valid && !uartif.PAR_TYP) 
         |=> (uart.parity_bit == ~^$past(uartif.P_DATA));
    endproperty
    assert property (check5) else $error("error in check5");
    cover property (check5);       

    property check6;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==START) 
         |=> (uartif.TX_OUT==1'b0 && uart.state==DATA && uart.counter==8'b00000000);
    endproperty
    assert property (check6) else $error("error in check6");
    cover property (check6);  

    property check7;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==DATA) 
         |=> (uartif.TX_OUT==$past(uart.data_reg[uart.counter]));
    endproperty
    assert property (check7) else $error("error in check7");
    cover property (check7);    

    property check8;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==DATA) 
         |=> (uart.counter==$past(uart.counter) + 1'b1);
    endproperty
    assert property (check8) else $error("error in check8");
    cover property (check8);    

    property check9;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==DATA && uart.counter == 7) 
         |=> (uart.state== (uartif.PAR_EN) ? PARITY : STOP);
    endproperty
    assert property (check9) else $error("error in check9");
    cover property (check9);

    property check10;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==PARITY) 
         |=> (uartif.TX_OUT== $past(uart.parity_bit));
    endproperty
    assert property (check10) else $error("error in check10");
    cover property (check10);    

    property check11;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==PARITY) 
         |=> (uart.state==STOP);
    endproperty
    assert property (check11) else $error("error in check11");
    cover property (check11); 

    property check12;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==STOP) 
         |=> (uartif.TX_OUT==1'b1 && uart.state==IDLE);
    endproperty
    assert property (check12) else $error("error in check12");
    cover property (check12);        

    property check13;
        @(posedge uartif.clk) disable iff (!uartif.rst_n)
         (uart.state==IDLE || uart.state==STOP) 
         |=> (uartif.TX_OUT);
    endproperty
    assert property (check13) else $error("error in check13");
    cover property (check13);    

endmodule

