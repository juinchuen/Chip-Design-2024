setenv LMC_TIMEUNIT -9
vlib work
vmap work work


# compile
vlog -work work "fft_tb.sv"
vlog -work work "fftFlat.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.fft_tb -wlf fft_tb.wlf


# wave 
#add wave -noupdate -group TOP -radix signed fft_tb/* fft_tb/input_Re fft_tb/input_Im fft_tb/output_Re fft_tb/output_Im fft_tb/fft/*
# add wave -noupdate -group TOP -radix signed fft_tb/fft/Butterfly/Apply_Twiddle1/* fft_tb/fft/Butterfly/Apply_Twiddle2/*
add wave -noupdate -group TOP -radix signed fft_tb/fft/Butterfly/* fft_tb/fft/Butterfly/Apply_Twiddle1/*
# add wave -noupdate -group TOP -radix signed fft_tb/fft/Butterfly/Apply_Twiddle2/* fft_tb/fft/Butterfly/twiddle_index_1_Re fft_tb/fft/Butterfly/twiddle_index_1_Im fft_tb/fft/Butterfly/twiddle_index_2_Re fft_tb/fft/Butterfly/twiddle_index_2_Im

run -all
