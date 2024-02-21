`timescale 1ns/10ps

module parity(
    input logic clk, 
    input logic rstb, 
    input logic [31:0] n, 
    input logic [31:0] arr[],
    output logic [31:0] parity
);
    logic [31:0] p = 0;
	logic [31:0] iter = 0;
	logic [31:0] iter2 = 0;

	always_ff @(negedge clk or negedge rstb) begin
		// reset vars
		if (!rstb) begin
			p <= 0;
			iter <= 0;
			iter2 <= 0;
			parity <= 0;
		end else if (negedge clk) begin
			if (iter < n) begin
				if (iter != ((1 << p) - 1)) begin
					p <= p + 1;
				end else begin
					p <= p + 1;
					iter <= iter + (1 << p) - 2;
				end
			end

			if (iter2 < n) begin
				if ((iter & ((1 << p) - 1)) == 0) begin
					parity = parity ^ arr[iter];
				end
				iter2 <= iter2 + 1;
			end
		end
	end
endmodule

module decode (
	input logic clk, 
    input logic rstb, 
	input logic [31:0] n,
	input logic [31:0] received[],
	output logic no_error,
	output logic [31:0] data[],
);
	logic [31:0] r = 0;
	logic [31:0] iter = 0;
	logic [31:0] d_iter = 0;
	logic [31:0] tmp_e = 0;
	logic [31:0] parity_bits;

	always_ff @(negedge clk or negedge rstb) begin
		if (!rstb) begin
			r <= 0;
			tmp_e <= 0;
			d_iter <= 0;
			
		end else if (negedge clk) begin
			// find R
			if ((1 << r) < (n + r + 1)) begin
				r <= r + 1;
			end

			// checking for errors
			for (iter = 0; iter < r; iter = iter + 1) begin
				// get parity bits
				parity p_inst(
					.clk(clk), 
					.rstb(rstb), 
					.n(n+r), 
					.arr(received),
					.parity(parity_bits)
				);

				// compare received data to expected data -> return error index
				if (parity_bits != received[(1 << iter) - 1]) begin
					tmp_e = tmp_e + (1 << iter) - 1
				end
			end

			// error correction: flip offending bit
			corr_received = received;
			if (tmp_e != 0) begin
				corr_received[tmp_e - 1] <= corr_received[tmp_e - 1] ^ 1;
			end

			// remove the parity values
			d_iter = 0;
			for (iter = 0; iter < (n + r); iter = iter + 1) begin
				if ((iter & (iter + 1)) != 0) begin
					data[d_iter] <= corr_received[iter];
					d_iter <= d_iter + 1;
				end
			end
		end
	end

	// Confirm there were no errors
	assign no_error = (tmp_e == 0);
endmodule