/////////////////////////////////////////////////////////////////////////////////////////////////
// File Name            : ctrlfsm.v                                                            // 
// Port Description     : Inputs   : i_clk , i_resetn , i_start                                //
//                        Outputs  : out_reset , out_load , out_enable                         //
//                                                                                             //
//                                                                                             // 
/////////////////////////////////////////////////////////////////////////////////////////////////

//Main Module
module fsm (
    input  i_clk,
    input  i_resetn,
    input  i_start,
    output out_reset,
    output out_load,
    output out_enable
);
  reg [1:0] state, next_state;
  parameter s0 = 0,  // Reset State
  s1 = 1,  // Load state
  s2 = 2;  // Enable state

  always @(*) begin
    case (state)
      s0: next_state = (i_resetn) ? s1 : s0;
      s1: begin
        if (!i_resetn) next_state = s0;
        else next_state = s2;
      end
      s2: begin
        if (!i_resetn) next_state = s0;
        else if (i_start) next_state = s2;
        else next_state = s0;
      end
    endcase
  end

  assign out_reset  = ~i_resetn;
  assign out_load   = (state == s1);
  assign out_enable = (state == s2) & i_start;

  always @(posedge i_clk) begin
    if (~i_resetn) state <= s0;
    else state <= next_state;
  end

endmodule

//Testbech
/*module fsm_tb();
reg i_clk , i_resetn , i_start;
wire out_load,out_enable;
fsm  tb (i_clk ,i_resetn, i_start , out_reset , out_load , out_enable );
initial begin
i_clk = 0; i_resetn=1; i_start=0;
#4 i_resetn = 0 ;
#2 i_start = 1;
#2 i_resetn = 1 ; i_start =0 ;
#2 i_start =1 ;
#8 i_start = 0 ;
end
always #1 i_clk = ~ i_clk ;
endmodule 
*/

