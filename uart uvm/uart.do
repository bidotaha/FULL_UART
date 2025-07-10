vlib work
vlog -f uart_files.list 
vsim -voptargs=+acc work.uart_top -classdebug -uvmcontrol=all
add wave /uart_top/uartif/*
run -all