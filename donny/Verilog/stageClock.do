setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "stageClock_tb.sv"
vlog -work work "fft.sv"

vsim -classdebug -voptargs=+acc +notimingchecks -L work work.stageClock_tb -wlf stageClock_tb.wlf

# wave
add wave -noupdate -group TOP -radix binary stageClock_tb/*

run -all
