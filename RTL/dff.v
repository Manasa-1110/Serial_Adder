/////////////////////////////////////////////////////////////////////////////////////////////////
// File Name            : dff.v                                                                //
// Port Description     : Inputs   :  i_clk , i_reset , i_d                                     //
//                        Outputs  : out_q                                                     //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


//Main Module
module dff (
    input i_clk,
    input i_reset,
    input i_d,
    output reg out_q
);

  always @(posedge i_clk) begin
    if (i_reset) out_q <= 0;
    else out_q <= i_d;
  end

endmodule


/*Test Bench
module dff_tb();
wire out_q ;
reg i_clk , i_reset ,i_d;
dff df(i_clk,i_reset, i_d,out_q );
initial begin
i_clk = 0 ; i_reset = 0 ;i_d= 0;
#2 i_reset = 1 ;
#2i_d= 1;
#2 i_reset = 0 ; i_d= 0;
#2 i_d= 1;
end
always #1 i_clk=~i_clk;
endmodule
*/
