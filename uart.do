vlib work
vlog -f src_files.list  +cover -covercells
vsim -voptargs=+acc work.uart_top -cover 
add wave *
add wave /uart_top/u_if/*
add wave /uart_top/RX/*
add wave /uart_top/TX/* 
coverage exclude -du uart_tx -togglenode {state[3]}
coverage exclude -src uart_tx.sv -line 14 -code b
coverage save uart_cov.ucdb -onexit -du uart_tx
run -all
coverage exclude -cvgpath /uart_pkg/uart_class/cvr_gp/TX_OUT_cross_Busy/<zero,zero>
##quit -sim
##vcover report uart_cov.ucdb -details -annotate -all -output Coverage_rpt_UART_sv.txt

