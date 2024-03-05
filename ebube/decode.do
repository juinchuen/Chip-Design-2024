setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "decode_tb.sv"
vlog -work work "decode.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.decode_tb -wlf decode_tb.wlf

# wave
add wave -noupdate -group TOP -radix unsigned decode_tb/*

run -all