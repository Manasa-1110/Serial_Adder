module serialadder_tb;
  parameter WIDTH = 8;
  reg i_clk, i_resetn, i_start;
  reg [WIDTH-1:0] i_a, i_b;
  wire [WIDTH : 0] out_sum;
  string testname;
  int seed;

  serial_adder #(WIDTH) serialadder_tb (
      .i_clock(i_clk),
      .i_resetn(i_resetn),
      .i_start(i_start),
      .i_a(i_a),
      .i_b(i_b),
      .o_sum(out_sum)
  );
  task test1;
	  repeat (2)@(posedge i_clk)i_resetn=1;
	  repeat (2) @(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  i_start = 1;
	  repeat(35)@(posedge i_clk);
  endtask:test1

  task test2;
	  repeat(2)@(posedge i_clk)i_start =0 ;
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat(2) @(posedge i_clk);
	  i_start=1;
	  repeat(35)@(posedge i_clk);
  endtask:test2

  task test3;
	  repeat(2)@(posedge i_clk)
	  i_start = 0;
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
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
  endtask:test3

  task test4;
	  repeat(2)@(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
      i_start = 0;
      i_resetn = 1;
	  repeat (2)@(posedge i_clk);
	  i_start=1;
	  repeat (35) @(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (2)@(posedge i_clk); i_start =0;
	  repeat (6) @(posedge i_clk); i_start = 1;
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (40) @(posedge i_clk);
	  repeat (2)@(posedge i_clk); i_start =0;
	  repeat (6) @(posedge i_clk); i_start = 1;
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (40) @(posedge i_clk);

  endtask:test4

  task test5;
	  repeat(2)@(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
      i_start = 1;
      i_resetn = 0;
	  repeat (2)@(posedge i_clk);
	  i_resetn=1;
	  repeat (20) @(posedge i_clk);
	  i_resetn=0;
	  repeat (2) @(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (50) @(posedge i_clk);
	  repeat (2)@(posedge i_clk); i_start =0;
	  repeat (6) @(posedge i_clk); i_start = 1;
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (40) @(posedge i_clk);
	  repeat (2)@(posedge i_clk); i_start =0;
	  repeat (6) @(posedge i_clk); i_start = 1;
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (40) @(posedge i_clk);

  endtask

  task test6;
	  repeat(2)@(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
      i_start = 1;
      i_resetn = 1;
	  repeat (35) @(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
	  repeat (35) @(posedge i_clk);
  endtask

  task default_test;
	  repeat (2)@(posedge i_clk) ; i_start=1;
      repeat (2) @(posedge i_clk);
	  i_a = $urandom_range(0,255);
      i_b = $urandom_range(0,255);
      repeat (2) @(posedge i_clk);
      i_resetn = 0;
      repeat (3) @(posedge i_clk);
      i_resetn = 1;
	  repeat (30)@(posedge i_clk);
  endtask:default_test



  initial begin
    i_clk = 0;
    i_resetn = 0;
    i_start = 0;
    i_a = 0;
    i_b = 0;
	if (!$value$plusargs("SEED=%d", seed))
		seed=1;
	void'($urandom(seed));
    if (!$value$plusargs("TEST=%s", testname))
	    testname = "default_test";
    $display("Running test: %s", testname);
    case (testname)
	    "test1": test1();
	    "test2": test2();
	    "test3": test3();
	    "test4": test4();
		"test5": test5();
		"test6": test6();
		"test7": begin test1();
		test2(); end
		"test8": begin test3();
		test4(); end
		"test9": begin test4();
		test5();end
		"test10": begin test5();
		test6();end
	    default: default_test();
    endcase
	 #50 $finish ;
  end


  initial $monitor("Time= %0d , i_a = %0d , i_b = %0d , out_sum = %0d ", $time, i_a, i_b, out_sum);

  always #1 i_clk = ~i_clk;

endmodule

