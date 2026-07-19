/////////////////////////////////////////////////////////////////////////////////////////////////
// File Name            : serial_adder.v                                                       //
// Port Description     : Inputs   : i_clk , i_resetn , i_start , i_a , i_b                    //
//                        Outputs  : out_sum                                                   //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////

`include "piso.v"
`include "f_adder.v"
`include "dff.v"
`include "ctrlfsm.v"
`include "sipo.v"


//Main Module
module serial_adder #(
    parameter WIDTH =4
) (
    input i_clk,
    input i_resetn,
    input i_start,
    input [WIDTH-1 : 0] i_a,
    input [WIDTH-1:0] i_b,
    output [WIDTH:0] out_sum
);

  wire sr_a, sr_b, sum_out, c_out, reset, load, enable, carry_in;
  reg [WIDTH+2:0] count;
  wire [WIDTH:0] sum;


// Instantiation of Control FSM
  fsm cf (
      i_clk,
      i_resetn,
      i_start,
      reset,
      load,
      enable
  );

// Instantiation of Parallel-In-Serial-out Shift Register
  piso #(WIDTH) piso1 (
      i_clk,
      i_a,
      load,
      enable,
      sr_a
  );
  piso #(WIDTH) piso2 (
      i_clk,
      i_b,
      load,
      enable,
      sr_b
  );

// Instantiation of Full adder
  f_adder fa (
      sr_a,
      sr_b,
      carry_in,
      sum_out,
      c_out
  );

//Instantiation of D-Flipflop
  dff df (
      i_clk,
      reset,
      c_out,
      carry_in
  );

//Instantiation of Serial-In-Parallel-out Shift Register
  sipo #(WIDTH) ss (
      i_clk,
      reset,
      sum_out,
      enable,
      sum
  );

//Counter to Output the Final Sum
  always @(posedge i_clk) begin
    if (!enable) begin
      count <= 1;
    end else count <= count << 1;
  end
  assign out_sum = (reset) ? 1'b0 :( (count[WIDTH+2]) ? sum : out_sum);

endmodule


/*//Test Bench
module sa_tb;

  parameter WIDTH = 8;
  reg i_clk, i_resetn, i_start;
  reg [WIDTH-1:0] i_a, i_b;
  wire [WIDTH : 0] out_sum, sum;

  serial_adder #(WIDTH) tb (
      i_clk,
      i_resetn,
      i_start,
      i_a,
      i_b,
      out_sum,
      sum
  );

  initial begin
    i_clk = 0;
    i_resetn = 0;
    i_start = 0;
    i_a = 0;
    i_b = 0;
    repeat (1) @(posedge i_clk);
    i_resetn = 1;
    repeat (2) @(posedge i_clk);
    i_resetn = 0;
    repeat (2) @(posedge i_clk);
    i_resetn = 1;
    i_a = 8'b01101110;
    i_b = 8'b01100101;
    i_start = 1;
    repeat (15) @(posedge i_clk);
    i_start = 0;
    i_a = 8'b10010001;
    i_b = 8'b10011011;
    repeat (2) @(posedge i_clk);
    i_start = 1;
    repeat (15) @(posedge i_clk);
    i_start = 0;
    i_a = 8'hff;
    i_b = 8'hff;
    repeat (2) @(posedge i_clk);
    i_resetn = 0;
    repeat (2) @(posedge i_clk);
    i_resetn = 1;
    @(posedge i_clk);
    i_resetn = 0;
    repeat (2) @(posedge i_clk);
    i_resetn = 1;
    i_start = 1;
    repeat (10) @(posedge i_clk);
    i_resetn = 0;
    repeat (3) @(posedge i_clk);
    i_a = 0;
    i_b = 0;
    i_start = 0;
    i_resetn = 1;
    repeat (2)@(posedge i_clk) ; i_start=1;
    repeat (2) @(posedge i_clk);
    i_a = $urandom_range(0,255);
    i_b = $urandom_range(0,255);
    repeat (2) @(posedge i_clk);
    i_resetn = 0;
    repeat (3) @(posedge i_clk);
    i_resetn = 1;


  end
  initial $monitor("Time= %0d , i_a = %d , i_b = %d , out_sum = %d ", $time, i_a, i_b, out_sum);


  always #1 i_clk = ~i_clk;



endmodule
*/







