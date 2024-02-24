setenv LMC_TIMEUNIT -9
vlib work
vmap work work


# compile
vlog -work work "twiddleFactorIndex_tb.sv"
vlog -work work "fft.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.twiddleFactorIndex_tb -wlf twiddleFactorIndex_tb.wlf


# wave
add wave -noupdate -group TOP -radix binary twiddleFactorIndex_tb/*




run -all
