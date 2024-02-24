setenv LMC_TIMEUNIT -9
vlib work
vmap work work


# compile
vlog -work work "countTo64_tb.sv"
vlog -work work "fft.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.countTo64_tb -wlf countTo64_tb.wlf


# wave
add wave -noupdate -group TOP -radix binary countTo64_tb/*




run -all
