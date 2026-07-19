/////////////////////////////////////////////////////////////////////////////////////////////////
// File Name            : sipo.v                                                               // 
// Port Description     : Inputs   : i_clk , i_reset , i_a , i_shift                           //
//                        Outputs  : out_q                                                     //
//                                                                                             //
//                                                                                             // 
/////////////////////////////////////////////////////////////////////////////////////////////////

//Main module
module sipo #(
    parameter WIDTH
) (
    input i_clk,
    input i_reset,
    input i_a,
    input i_shift,
    output reg [WIDTH:0] out_q
);
  reg [WIDTH:0] aa;
  always @(posedge i_clk) begin
    if (i_reset) {aa, out_q} <= 0;
    else if (i_shift) begin
      aa <= {i_a, aa[WIDTH:1]};
    end

    assign out_q = aa;
  end
endmodule


//Test bench
/*module sipo_tb();
parameter WIDTH = 6;
reg i_reset , i_shift , i_clk ;
reg a;
wire [WIDTH:0] q ;
sipo #(WIDTH) tb(i_clk ,i_reset, a, i_shift , q);
initial begin
a=0;i_reset=0; i_shift = 0 ;i_clk = 0; 
#2 a=0 ;i_reset = 1;
#2 a=1;
#2 i_reset= 0  ;i_shift = 1;
#2 a= 0;
#2 a=1 ;
#2 a= 0;
#2 a=1 ; i_shift = 0 ;
#2 i_shift =1;
end
always #1 i_clk = ~i_clk ;
endmodule
*/
