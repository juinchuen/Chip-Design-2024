module sequence_detector (
  input logic clk,
  input logic rst,
  input logic in,
  output logic out
);

typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} FSM_State;
FSM_State state, next_state;

always_ff @ (posedge clk, posedge rst) begin
  if (rst) begin
    state <= S0;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  case (state) 
    S0: begin
      next_state = in ? S1 : S0;
      out = 0;
    end

    S1: begin
      next_state = in ? S2 : S0;
      out = 0;
    end

    S2: begin
      next_state = in ? S3 : S0;
      out = 0;
    end

    S3: begin
      next_state = in ? S4 : S0;
      out = 0;
    end

    S4: begin
      next_state = in ? S5 : S0;
      out = 0;
    end

    S5: begin
      next_state = S0;
      out = 1;
    end

    default: begin
      next_state = S0;
      out = 0;
    end
  endcase
end

endmodule