setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "top_tb.sv"
vlog -work work "core.sv"
vlog -work work "fpga_top.sv"
vlog -work work "../uart/Verilog/source/UART_TX.v"
vlog -work work "../uart/Verilog/source/UART_RX.v"
vlog -work work "transceiver_no_ecc.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.top_tb -wlf top_tb.wlf

# wave
add wave -noupdate -group TB -radix hexadecimal /top_tb/*

add wave -noupdate -group TOP -radix hexadecimal /top_tb/uTop/*

add wave -noupdate -group CORE -radix hexadecimal /top_tb/uTop/uCore/*





run -all