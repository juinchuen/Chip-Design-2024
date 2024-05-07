setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "top_tb.sv"
vlog -work work "../uart/Verilog/source/UART_TX.v"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.top_tb -wlf top_tb.wlf

# wave
add wave -noupdate -group TOP -radix hexadecimal /top_tb/*


run -all