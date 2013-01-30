// Simple VCS PLI example.
//
// The testbench 'test' instantiates a submodule called 'stub' which is a wrapper around the
// embedded PLI model.
//
module test;

// Testbench I/O
reg		clk;
reg		reset;
reg [3:0]	m;
reg		mwe;
wire [3:0]	q;

// *** Instantiate the stub ***
//
stub stub (
   .clk		(clk),
   .reset	(reset),
   .m		(m),
   .mwe		(mwe),
   .q		(q)
);

// *** Call the main test ***
//
initial begin
   main_test;
end

// *** General Testbench Tasks ***
task drive_clock;
   begin
      clk = 0;
      forever begin
         #10 clk = ~clk;
      end
   end
endtask

// Reset everything.
task drive_reset;
   begin
      reset = 1;
      #33;
      reset = 0;
   end
endtask

// *** The main test ***
parameter MAX_CYCLES = 100;

task main_test;
   begin
      $display ("Verilog PLI Test!");
      m = 0;
      mwe = 0;
      
      fork
         // Drive the main clock
         drive_clock;
         
         // Reset
         drive_reset;
         
         // Are we done?
         begin
            repeat (MAX_CYCLES) @(posedge clk);
            $finish;
         end
         
         // Monitor output of this stub
         begin
            forever begin
               @(posedge clk);
               $display ("Stub q output = %d", q);
            end
         end
               
         // Control the 'm' input.
         begin
            // Every 25 cycles.. Let's randomly change the modulo value
            forever begin
               repeat (25) @(posedge clk);
               m = (3 + $random) & 15;
               mwe = 1;
               @(posedge clk);
               mwe = 0;
            end
         end
      join
   end
endtask

endmodule

// This "stub" is filled in with the PLI calls.  It is a wrapper for the Verilog world.
//
module stub (clk, reset, m, mwe, q);
input		clk;
input		reset;
input [3:0]	m;
input		mwe;
output [3:0]	q;

reg [3:0]	q;

initial begin
   // Drive and monitor the PLI model
   drive_pli;
end         

// This task drives the PLI model.  It reacts to each clock cycle in Verilog and makes all the
// required calls to the PLI model underneath.
//
task drive_pli;
   begin
      // Drive PLI inputs and extract outputs every cycle
      //
      forever begin
         // PLI model is cycle-based.
         @(posedge clk);
         
         // For every cycle, do whatever PLI calls necessary.
         if (reset) begin
            // Reset.  Reset the PLI model.
            $mypli_reset;
         end
         else begin
            // Just another regular system cycle.  Call the primary PLI function to nudge the model one cycle.
            $mypli_cycle;
            
            // Extract outputs of the PLI model into our Verilog variables.
            $mypli_getcount (q);
         end
         
         // If the mwe signal is asserted then the current 'm' value should be input into the PLI.
         // We could have also had a single function that gathers all the inputs together and offered
         // them to the PLI model.. Or, we could let the PLI model go get the variables on its own.
         // 
         if (mwe) begin
            $mypli_setmodulo (m);
         end
      end
   end
endtask

endmodule

