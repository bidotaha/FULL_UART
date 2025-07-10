module uart_sva_rx (uart_if.RX u_if);
    
    always_comb begin
        if(!u_if.reset)
       assert_reset: assert final ((uart_rx.DATA_reg==0)&&(!u_if.RX_DONE)&&(!u_if.PAR_OUT)&&(uart_rx.cs==u_if.IDLE)&&(uart_rx.counter==0));
        cover_reset:cover final ((uart_rx.DATA_reg==0)&&(!u_if.RX_DONE)&&(uart_rx.cs==u_if.IDLE)&&(uart_rx.counter==0));
    end

    property IDLE_Behaviour1_p;
    @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_rx.cs==u_if.IDLE) && (u_if.Busy) )|=>
                          (uart_rx.ns == u_if.START) [=1] ;
    endproperty

      property IDLE_Behaviour2_p;
       @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_rx.cs==u_if.IDLE))|=> 
                           (uart_rx.DATA_reg==0) ;
                          
      endproperty
      property IDLE_Behaviour3_p;
       @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_rx.cs==u_if.IDLE))|=> 
                           (uart_rx.counter==0) ;
                          
      endproperty

      property IDLE_Behaviour4_p;
       @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_rx.cs==u_if.IDLE))|=> 
                           (u_if.PAR_OUT==0) ;
                          
      endproperty   
      property IDLE_Behaviour5_p;
       @(posedge u_if.clk) disable iff(!u_if.reset) 
                       ((uart_rx.cs==u_if.IDLE))|=> 
                           (u_if.RX_DONE==0) ;
                          
      endproperty         
    property START_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_rx.cs==u_if.START) |=>
                          (uart_rx.ns==u_if.DATA) && (uart_rx.counter==0);
    endproperty
    property DATA_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        ((uart_rx.cs==u_if.DATA)) |=>
                         (uart_rx.DATA_reg[$past(uart_rx.counter)] == $past(u_if.TX_OUT)) && (uart_rx.counter==$past(uart_rx.counter)+1);
    endproperty
    property DATA_Behaviour1_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_rx.cs==u_if.DATA)&&(uart_rx.counter==7)&&(u_if.PAR_EN==1) |=>
                          (uart_rx.ns==u_if.PARITY)[=1];
    endproperty
    property DATA_Behaviour2_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)  
                        (uart_rx.cs==u_if.DATA)&&(uart_rx.counter==7)&&(u_if.PAR_EN==0) |=>
                          (uart_rx.ns==u_if.STOP)[=1];
    endproperty
    property PARITY_Behaviour1_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_rx.cs==u_if.PARITY) |=>
                         (u_if.PAR_OUT==$past(u_if.TX_OUT));
    endproperty
    property PARITY_Behaviour2_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_rx.cs==u_if.PARITY) |=>
                         (uart_rx.ns==u_if.STOP)[=1];
    endproperty    
     property STOP_Behaviour_p;
    @(posedge u_if.clk) disable iff(!u_if.reset)
                        (uart_rx.cs==u_if.STOP) |=>
                         (u_if.P_DATA_OUT==$past(uart_rx.DATA_reg)) && (u_if.RX_DONE) && (uart_rx.ns==u_if.IDLE);
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

// PARITY State Property
assert property (PARITY_Behaviour1_p);
cover property (PARITY_Behaviour1_p);

assert property (PARITY_Behaviour2_p);
cover property (PARITY_Behaviour2_p);

// STOP State Property
assert property (STOP_Behaviour_p);
cover property (STOP_Behaviour_p);


    
endmodule