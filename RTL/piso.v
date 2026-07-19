/////////////////////////////////////////////////////////////////////////////////////////////////
// File Name            : piso.v                                                               // 
// Port Description     : Inputs   : i_clk , i_a , i_load , i_shift                            //
//                        Outputs  : out_q                                                     //
//                                                                                             //
//                                                                                             // 
/////////////////////////////////////////////////////////////////////////////////////////////////

module piso #(
    parameter WIDTH
) (
    input i_clk,
    input [WIDTH-1:0] i_a,
    input i_load,
    input i_shift,
    output reg out_q
);
  reg [WIDTH-1:0] aa;
  always @(posedge i_clk) begin
    if (i_load) begin
      aa <= i_a;
      out_q <= 0;
    end else if (i_shift) begin
      out_q <= aa[0];
      aa = {1'b0, aa[WIDTH-1:1]};
    end else out_q <= 0;
  end
endmodule

/*module piso_tb();
parameter WIDTH = 4;
reg i_load , i_shift , i_clk ;
reg [WIDTH-1:0]a;
wire q ;
piso #(WIDTH) tb(i_clk , a,i_load , i_shift , q);
initial begin
a=0;i_load = 0; i_shift = 0 ;i_clk = 0; 
#2 a= 4'b1010;
#2 i_load = 1;
#2 i_load = 0 ;
#2 i_shift = 1;
#10 i_shift = 0 ;
end
always #1 i_clk = ~i_clk ;
endmodule
*/
