setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "tb/fir_tb_1.sv"
vlog -work work "fir.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.fir_tb -wlf fir_tb.wlf

# wave
add wave -noupdate -group TOP -radix binary fir_tb/*
add wave -noupdate -group UUT -radix decimal fir_tb/UUT/*
add wave -noupdate -group UUT -radix decimal fir_tb/UUT/sd/*

run -all
