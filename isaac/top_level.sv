module top_level #(
  parameter BIT_WIDTH = 16;
) (
  input logic [BIT_WIDTH - 1 : 0] i_data
  input logic i_clk, i_rstb

  output reg [BIT_WIDTH - 1 : 0] o_data [63:0]
  output o_start_bit
);

typedef enum logic [3:0] 
{s_IDLE, s_FFT_RECEIVE, s_FFT_WAIT, s_FFT_SEND, s_IFFT_RECEIVE, s_IFFT_WAIT, s_IFFT_SEND, s_FFT_RECEIVE} 
FSM_State;

reg r_current_reg = 6'd0; // count up to 64

always @(posedge i_clk) begin

  if (i_rstb) begin
    FSM_State <= s_IDLE;
  end

  case (FSM_State)
    s_IDLE: begin  
      r_current_reg <= 4'd0; // reset register counter

      if (i_data[1:0] == 2'b00) begin // idle state
        FSM_State <= s_IDLE;
      end else if (i_data[1:0] == 2'b01) begin // FFT mode
        FSM_State <= s_FFT_RECEIVE;
      end else if (i_data[1:0] == 2'b10) begin // IFFT mode
        FSM_State <= s_IFFT_RECEIVE;
      end else if (i_data[1:0] == 2'b11) begin // FIR mode
        FSM_State <= s_FIR;
      end
    end

    s_FFT_RECEIVE: begin
      
    end
  endcase

end
  
endmodule