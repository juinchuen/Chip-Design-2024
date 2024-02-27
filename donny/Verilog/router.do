setenv LMC_TIMEUNIT -9
vlib work
vmap work work


# compile
vlog -work work "router_tb.sv"
vlog -work work "fft.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.fft_tb -wlf fft_tb.wlf


# wave
add wave -noupdate -group TOP -radix binary fft_tb/*




run -all
