setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# compile
vlog -work work "tb/fir_top_tb.sv"
vlog -work work "src/core.sv"
vlog -work work "src/fpga_top.sv"
vlog -work work "../uart/Verilog/source/UART_TX.v"
vlog -work work "../uart/Verilog/source/UART_RX.v"
vlog -work work "src/transceiver_no_ecc.sv"
vlog -work work "../../donny/Verilog/fft.sv"
vlog -work work "../../donny/Verilog/registerMux.sv"
vlog -work work "../../donny/Verilog/twiddle_factor_mux.sv"
vlog -work work "../../donny/Verilog/signal_router.sv"
vlog -work work "../../quan/fir.sv"
vlog -work work "../../quan/modules/halfword_shift.sv"
vlog -work work "../../quan/modules/sequence_detector.sv"


vsim -classdebug -voptargs=+acc +notimingchecks -L work work.top_tb -wlf top_tb.wlf

# wave
add wave -noupdate -group TB -radix hexadecimal /top_tb/*

add wave -noupdate -group TOP -radix hexadecimal /top_tb/uTop/*

add wave -noupdate -group CORE -radix hexadecimal /top_tb/uTop/uCore/*

# add wave -noupdate -group FFT -radix hexadecimal /top_tb/uTop/uCore/uFFT/*

add wave -noupdate -group FIR -radix hexadecimal /top_tb/uTop/uCore/uFIR/*

run -all