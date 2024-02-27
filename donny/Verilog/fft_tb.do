setenv LMC_TIMEUNIT -9
vlib work
vmap work work


# compile
vlog -work work "fft_tb.sv"
vlog -work work "fft.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.fft_tb -wlf fft_tb.wlf


# wave
# add wave -noupdate -group TOP -radix unsigned fft_tb/* fft_tb/input_Re fft_tb/input_Im fft_tb/output_Re fft_tb/output_Im fft_tb/fft/*
add wave -noupdate -group TOP -radix binary fft_tb/fft/Butterfly/*



run -all
