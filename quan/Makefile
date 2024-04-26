help:
	@echo "Usage: make do tb=<number>"
	@echo "Example: make do tb=2"

run:
	@if [ -z "$(fir)" ]; then \
			echo "Error: FIR number is not specified. Usage: make run fir=<number>"; \
			exit 1; \
	fi
	vsim -do do/fir_$(fir).do