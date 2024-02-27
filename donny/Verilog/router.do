setenv LMC_TIMEUNIT -9
vlib work
vmap work work


# compile
vlog -work work "router_tb.sv"
vlog -work work "fft.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.router_tb -wlf router_tb.wlf


# wave
add wave -noupdate -group TOP -radix unsigned router_tb/*




run -all
