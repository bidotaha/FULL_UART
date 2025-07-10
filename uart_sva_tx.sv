module uart_sva_tx (uart_if.TX u_if);
    
    always_comb begin
        if(!u_if.reset)
       assert_reset: assert final ((u_if.TX_OUT)&&(!u_if.Busy)&&(uart_tx.state==u_if.IDLE)&&(uart_tx.counter==0));
        cover_reset:cover final ((u_if.TX_OUT)&&(!u_if.Busy)&&(uart_tx.state==u_if.IDLE)&&(uart_tx.counter==0));
    end

    property IDLE_Behaviour1_p;
    @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_tx.state==u_if.IDLE) && (~u_if.DATA_VALID) )|=>
                         (u_if.TX_OUT == 1) && (!u_if.Busy) && (uart_tx.counter == 1'b0) ;
    endproperty

      property IDLE_Behaviour2_p;
       @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_tx.state==u_if.IDLE) && (~u_if.DATA_VALID) )|=> (uart_tx.state==u_if.IDLE) ;
                          
      endproperty
     property IDLE_Behaviour3_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.IDLE)&&(u_if.DATA_VALID) && (u_if.PAR_TYP==0) |=>
                         (uart_tx.PARITY_bit==~^$past(u_if.P_DATA)) && (u_if.Busy) && (uart_tx.DATA_reg==$past(u_if.P_DATA)) ;
    endproperty
     property IDLE_Behaviour4_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.IDLE)&&(u_if.DATA_VALID) && (u_if.PAR_TYP==1) |=>
                         (uart_tx.PARITY_bit==^$past(u_if.P_DATA)) && (u_if.Busy) && (uart_tx.DATA_reg==$past(u_if.P_DATA)) ;
    endproperty

    property IDLE_Behaviour5_p;
      @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.IDLE)&&(u_if.DATA_VALID) |=> (uart_tx.state==u_if.START);
      endproperty
    property START_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.START) |=>
                         (u_if.TX_OUT==0) && (uart_tx.state==u_if.DATA) && (uart_tx.counter==0);
    endproperty
    property DATA_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        ((uart_tx.state==u_if.DATA) && (uart_tx.counter != 7 )) |=>
                         ((u_if.TX_OUT)==uart_tx.DATA_reg[$past(uart_tx.counter)]) && (uart_tx.counter==$past(uart_tx.counter)+1);
    endproperty
    property DATA_Behaviour1_p;
      @(posedge u_if.clk) disable iff(!u_if.reset)
                        ((uart_tx.state==u_if.DATA) && (uart_tx.counter != 7 )) |=> (uart_tx.state==u_if.DATA) ;

      endproperty
    property DATA_Behaviour2_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.DATA)&&(uart_tx.counter==7)&&(u_if.PAR_EN==1) |=>
                          (uart_tx.state==u_if.PARITY);
    endproperty
    property DATA_Behaviour3_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)  
                        (uart_tx.state==u_if.DATA)&&(uart_tx.counter==7)&&(u_if.PAR_EN==0) |=>
                          (uart_tx.state==u_if.STOP);
    endproperty
    property PARITY_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.PARITY) |=>
                         (u_if.TX_OUT==$past(uart_tx.PARITY_bit)) &&(uart_tx.state==u_if.STOP);
    endproperty
     property STOP_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_tx.state==u_if.STOP) |=>
                         (u_if.TX_OUT==1) &&(uart_tx.state==u_if.IDLE);
    endproperty

    

   // IDLE State Properties
assert property (IDLE_Behaviour1_p);
cover property (IDLE_Behaviour1_p);

assert property (IDLE_Behaviour2_p);
cover property (IDLE_Behaviour2_p);

assert property (IDLE_Behaviour3_p);
cover property (IDLE_Behaviour3_p);

assert property (IDLE_Behaviour4_p);
cover property (IDLE_Behaviour4_p);

assert property (IDLE_Behaviour5_p);
cover property (IDLE_Behaviour5_p);

// START State Property
assert property (START_Behaviour_p);
cover property (START_Behaviour_p);

// DATA State Properties
assert property (DATA_Behaviour_p);
cover property (DATA_Behaviour_p);

assert property (DATA_Behaviour1_p);
cover property (DATA_Behaviour1_p);

assert property (DATA_Behaviour2_p);
cover property (DATA_Behaviour2_p);

assert property (DATA_Behaviour3_p);
cover property (DATA_Behaviour3_p);

// PARITY State Property
assert property (PARITY_Behaviour_p);
cover property (PARITY_Behaviour_p);

// STOP State Property
assert property (STOP_Behaviour_p);
cover property (STOP_Behaviour_p);


    
endmodule