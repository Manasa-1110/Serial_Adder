/////////////////////////////////////////////////////////////////////////////////////////////////
// File Name            : f_adder.v                                                            // 
// Port Description     : Inputs   : in_a , in_b , in_cin                                      //
//                        Outputs  : out_sum , out_cout                                        //
//                                                                                             //
//                                                                                             // 
/////////////////////////////////////////////////////////////////////////////////////////////////

//Main Module
module f_adder (
    input  in_a,
    input  in_b,
    input  in_cin,
    output out_sum,
    output out_cout
);
  assign {out_cout, out_sum} = in_a + in_b + in_cin;
endmodule


//Test Bench
/*module f_addtb();
reg in_a ,in_b ,in_cin;
wire out_sum , out_cout ;
f_adder f_tb(in_a,in_b,in_cin,out_sum,out_cout);
initial begin
in_a=0; in_b= 0; in_cin=0 ;
#2 in_a =1;
#2 in_b =1 ;
#2 in_a=0 ;
#2 in_cin =1 ; in_b = 0;
#2 in_cin = 1 ; in_b =1 ; in_a= 1;
end
endmodule
*/
