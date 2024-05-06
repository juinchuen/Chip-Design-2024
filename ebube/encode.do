setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "encode_tb.sv"
vlog -work work "encode.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.encode_tb -wlf encode_tb.wlf

# wave
add wave -noupdate -group TOP -radix unsigned encode_tb/*

run -all