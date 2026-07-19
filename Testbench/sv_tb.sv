class transaction #(parameter WIDTH = 4);
	randc bit i_start;
    randc bit [WIDTH-1:0] i_a;
    randc bit [WIDTH-1:0] i_b;
    bit [WIDTH:0] out_sum;

	constraint start{i_start dist {0:= 20 , 1:=80};}

	function transaction copy ();
		copy = new();
 		copy.i_start = this.i_start;
		copy.i_a = this.i_a;
		copy.i_b = this.i_b;
		copy.out_sum = this.out_sum;
	endfunction

	function void display (string name);
		$display ("[%s] -- a :%0d , b:%0d , result :%0d ",name, i_a, i_b , out_sum);
	endfunction

endclass


class generator #(parameter WIDTH= 4);
	transaction #(WIDTH) tg;
	mailbox #(transaction #(WIDTH)) gen2drv;
	event next;

	function new (mailbox #(transaction #(WIDTH)) gen2drv);
		this.gen2drv=gen2drv;
		tg = new();
	endfunction

	task run();
		forever begin
			for (int i=0 ; i<40 ; i++); begin
				assert(tg.randomize()) else $display("Randomization failed");
				gen2drv.put(tg);
				$display("[GEN] Sending data to driver " );
				tg.display("[GEN]");
				@(next);
end
		end
	endtask

endclass

class driver #(parameter WIDTH = 4);
	transaction #(WIDTH) td;
	mailbox #(transaction  #(WIDTH)) gen2drv;
	virtual intf #(WIDTH) intf_sa;
	event next;

	function new (mailbox #(transaction #(WIDTH)) gen2drv);
		this.gen2drv=gen2drv;
	endfunction

	task run();
		forever begin
			gen2drv.get(td);
			$display("[DRV] RCVD data from driver " );
			td.display("[DRV]");
			@(posedge intf_sa.i_clk);
			intf_sa.i_a <= td.i_a;
			intf_sa.i_b <= td.i_b;
			intf_sa.i_start <= td.i_start;
			$display("[DRV] : Interface Triggered ");
			$display("[intf] a:%0d , b :%0d , result :%0d", intf_sa.i_a,intf_sa.i_b,intf_sa.out_sum);
			repeat (10) @(posedge intf_sa.i_clk);
			-> next;
		end

	endtask

endclass

interface intf #(parameter WIDTH=4);
	logic i_clk;
    logic i_resetn;
    logic i_start;
    logic [WIDTH-1 : 0] i_a;
    logic [WIDTH-1:0] i_b;
    logic [WIDTH:0] out_sum;
endinterface

module serial_tb;
	parameter WIDTH=8;
    intf #(WIDTH) intf_sa();
	generator #(WIDTH) gen;
	driver #(WIDTH) drv;
	mailbox #(transaction#(WIDTH)) gen2drv;

	serial_adder #(WIDTH) serial_addtb ( .i_clk(intf_sa.i_clk) , .i_resetn(intf_sa.i_resetn) , .i_start(intf_sa.i_start) , .i_a(intf_sa.i_a) , .i_b(intf_sa.i_b) , .out_sum(intf_sa.out_sum));

	initial begin
		gen2drv=new();
		gen =new(gen2drv);
		drv= new (gen2drv);
		drv.intf_sa = intf_sa;
		gen.next= drv.next;

	end

	initial begin
		intf_sa.i_clk = 0;
		@(posedge intf_sa.i_clk);
		intf_sa.i_resetn = 1;
		@(posedge intf_sa.i_clk);
		intf_sa.i_resetn =0;
		repeat(3) @(posedge intf_sa.i_clk);
		intf_sa.i_resetn=1;
		repeat(30) @(posedge intf_sa.i_clk);
		intf_sa.i_resetn=0;
		repeat(2) @(posedge intf_sa.i_clk);
		intf_sa.i_resetn=1;
		@(posedge intf_sa.i_clk);
		intf_sa.i_resetn=0;
		@(posedge intf_sa.i_clk);
		intf_sa.i_resetn=1;
		repeat(300) @(posedge intf_sa.i_clk);
		intf_sa.i_resetn=0;
		repeat(2) @(posedge intf_sa.i_clk);
		intf_sa.i_resetn=1;
		@(posedge intf_sa.i_clk);
		intf_sa.i_resetn=0;

	end

	always #2 intf_sa.i_clk <= ~ intf_sa.i_clk;

	initial begin
		fork
			gen.run();
			drv.run();
		join
	end

	initial begin
		#3000 $finish;
	end

endmodule






