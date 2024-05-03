setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "../uart/Verilog/source/UART_RX.v"
vlog -work work "../uart/Verilog/source//UART_TX.v"
vlog -work work "../../ebube/decode.sv"
vlog -work work "transceiver.sv"
vlog -work work "transceiver_tb.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.transceiver_tb -wlf transceiver_tb.wlf

# wave
add wave -noupdate -group TOP -radix hexadecimal /transceiver_tb/*

add wave -noupdate -group TRX -radix hexadecimal /transceiver_tb/uTRX/*


run -all