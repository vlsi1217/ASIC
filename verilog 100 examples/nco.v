//
// NCO Demo (Numerically controlled Oscillator).
//
// One type of NCO is based on the idea of a continuously wrapping modulo
// counter.  The NCO is a programmable modulo counter.  For example, if
// the MOD input is set to 10, then it'll count 0,1,2,3,4,5,6,7,8,9,0,1,2 etc.
// The STEP input is continuously added to the modulo counter.  What's important
// is not the counter value itself, but the number of times it "wraps".  If
// you do the math, the counter will wrap at a rate of F*S/M (F is the system
// clock frequency, S is the step input, and M is the modulo).  Every wrap
// occurance is a little pulse.  The pulse output could be used as the clock itself
// except that it may have a very small duty cycle.  Instead, take the WRAP
// pulse signal and use it to increment a TICKS counter.  The TICKS counter will
// then count at the programmed frequency.
//
// The TICK counter could be used in itself for, say, a TDMA slot counter.  Any
// number of TICKS LSB bits can be thrown away to "reduce jitter" but also
// reduce the rate.  This NCO has a little MASK input and an internal OR gate
// so you can pick off whichever TICKS bits you wish for your final FOUT output.
//
// In an open-loop mode, you program your Modulo and Step inputs and you are done.
// If you are tracking some other reference (e.g. like in a PLL style circuit) you
// would somehow control STEP via some sort of "phase detector" and loop filter.
// None of this is shown here.
//
// Anyway, this is just the guts of the NCO, which can be applied in many, many
// ways.
//
// Oh.. And this NCO seems to be off by a small percentage..?!..  I'm not sure
// why.  It may be the circuit or the testbench.  Let me know if you play with it
// and find out.  My application is closed-loop, so, I'm not highly motivated
// to figure it out.
//
// Written by tom coonan
//
module nco (
   clk,
   resetb,
   step,	// Step input is continuously added to the modulo counter
   mod,		// modulo
   mask,	// Mask is ANDed with ticks and gen ORed to produce fout
   ticks,	// Tick counter output
   fout		// Output.
);

parameter W_ACCUM = 24; // Width of the Accumulator
parameter W_TICK  = 8; // Width of the Tick counter.
parameter W_STEP  = 24;
parameter W_MOD   = 24;

input			clk;
input			resetb;
input [W_STEP-1:0]	step;
input [W_MOD-1:0]	mod;
input [W_TICK-1:0]	mask;
output [W_TICK-1:0]	ticks;
output			fout;

// Registered outputs

// Internals
reg [W_ACCUM-1:0]	accum, accum_in;
reg [W_TICK-1:0]	ticks;

// *** Modulo Counter ***
// Registered outputs
reg		wrap;

wire [W_ACCUM-1:0]	sum = accum + step;
wire [W_ACCUM-1:0]	rem = sum - mod;
wire			over = (sum >= mod);

always @(posedge clk or negedge resetb)
   if (~resetb) accum <= 0;
   else         accum <= accum_in;
   
always @(over or rem or sum) begin
   if (over) begin
      // Wrap!
      accum_in <= rem; // load remainder instead of sum
      wrap <= 1;
   end
   else begin
      // No wrap, just add
      accum_in <= sum;
      wrap <= 0;
   end
end

// *** Tick Counter ***
//
always @(posedge clk) begin
   if (~resetb) ticks <= 0;
   else begin
      // Whenever Modulo counter wraps, increment the tick counter.
      if (wrap) 
         ticks <= ticks + 1;
   end
end

// *** Masks and final output *** //

assign fout = |(ticks & mask);

endmodule

module ncotest;

reg		clk;
reg		resetb;
reg [23:0]	step;
reg [23:0]	mod;
reg [7:0]	mask;
wire		fout;
wire [7:0]	ticks;	

parameter W_ACCUM = 24; // Width of the Accumulator
parameter W_TICK  = 8; // Width of the Tick counter.
parameter W_STEP  = 24;
parameter W_MOD   = 24;

nco nco1 (
   .clk(clk),
   .resetb(resetb),
   .step(step),
   .mod(mod),
   .mask(mask),
   .fout(fout),
   .ticks(ticks)
);

parameter PERIOD_NS = 36;
parameter DUMP_ON = 1;

real	sys_freq;

initial begin
   step = 0;
   mod = 0;
   mask = 8'b00000001; // Final Divider for FOUT
   
   sys_freq = 1000000000.0/(PERIOD_NS);
   
   #300;

   // Display the basic such as system clock frequency, etc.
   //
   $display ("NCO Test.  NCO Accumulator width is %0d bits, system clock period is %0d ns (%fMHz).",
      W_ACCUM,
      PERIOD_NS,
      sys_freq
   );
   
   // Program Modulo and Step for desired frequency.  Modulo and Step values should
   // not be divisible by each other (I'm not mathematically strong enough to
   // justify this...).  Find the ratio of S/M, integerize it, and reduce to lowest
   // common divisors.  Then, multiply up by a big power of 2 so we can get some
   // resolution on the NCO.
   // 
   
   // Let's generate 1Mhz, Fsys*(Step/Mod)/2 = 27777777.777*(S/M)/2 = 1000000
   //    S/M = 0.072 = 72/1000 = 9/125 (9 * 2^12) / (125 * 2^12)
   //
   mod  = 125 << 12; // Shift up so we get resolution..
   step =   9 << 12; // Shift up so we get resolution..
   nco_test (mod, step, 1000000); // Run test for specified interval (units are NS)
   
   // Generate 10.24MHz: Fsys*(Step/Mod)/2 = 27777777.777*(S/M)/2 = 10240000
   //    S/M = 0.73728 = 73728/100000 = 9216/12500 = 4608/6250 = 2304/3125
   //
   mod  = 3125 << 10; // Shift up so we get resolution..
   step = 2304 << 10; // Shift up so we get resolution..
   nco_test (mod, step, 1000000); // Run test for specified interval (units are NS)
   
   // Generate 32.768 KHz using TICKS MSB (divide by 8): 
   //    Fsys*(Step/Mod) = 27777777.777*(S/M) = 32768*256
   //    S/M = 0.301989888 =~ 0.302 = 302/1000 = 151/500
   //
   mask = 8'b10000000; // Divide by 256
   mod  = 500 << 12;
   step = (151 << 12) - 9566;  // Manually Tweaked this to get the right number..
                               // this is expected since didn't have a good integer
                               // ratio above..
   nco_test (mod, step, 1000000); // Run test for specified interval (units are NS)
      
   $display ("Done.");
   
   $finish;
end

// Run a single trial of the NCO test.
//   
task nco_test;
   input [23:0] mod_arg;
   input [23:0] step_arg;
   input	interval;
   
   integer	interval;   // Use $time..  Make sure timescale is correct!
   integer	start_time;
   integer	fout_edges;
   
   begin
      step = step_arg; // Configure NCO
      mod  = mod_arg;
      
      // Count rising edges on FOUT which is the output frequency
      fout_edges = 0;
      start_time = $time; // Note our starting time
      // Loop for at least the specified amount of time
      while ( ($time - start_time) < interval) begin
         @(posedge fout); // Wait for an edge on FOUT
         fout_edges = fout_edges + 1;
      end
      
      // Done.  Display results and expected results.
      $display ("For Mod=%0d(0x%h), Step=%0d(0x%h), Frequency of fout = %f Hz, Expected fout is %f Hz.",
         mod, mod,
         step, step,
         ((fout_edges*1.0)/($time - start_time))*1000000000.0, // measured..
         ((step*1.0)/(mod*1.0))*(sys_freq)/(mask*2.0)   // expected..
      );
   end
endtask

// Let's clock it at about 27 MHz
initial begin
   clk = 0;
   forever begin
      #(PERIOD_NS/2) clk = ~clk;
   end
end

initial begin
   resetb = 0;
   #200 resetb = 1;
end

initial begin
   if (DUMP_ON) begin
      $dumpfile ("nco.vcd");
      $dumpvars (0,ncotest);   
   end
end
endmodule
