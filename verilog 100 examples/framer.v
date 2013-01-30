//
// Simple example of a "framer".  In this case, an MPEG framer where
// data is sent in 188-byte frames which begin with a special SYNC character
// defined as 47 hex.  Framing must, of course, handle cases where 47s
// happen to also be embedded in the data.  Framer must be able to find
// the period SYNC characters while not be thrown off by spurious SYNCs.
//
// This circuit uses a modulo-188 counter that serves as a timestamp.
// Every received SYNC character causes the current modulo-188 counter
// to be pushed onto a little queue.  The idea is that the timestamps
// should all be the same if the data was perfectly framed.  If spurious
// false SYNC characters fall in the data, then some of the timestamps
// will be different.  This is OK as long as there is a clear majority.
//
// This circuit is something I started to actually have to do, but then
// I ended up not using it.  It is not tested, so use it only for ideas
// and not as a proven circuit!!
//
// tom coonan, 12/1999
//
module framer (clk, resetb, din, dinstb, dout, doutsync, doutstb, locked);
input		clk;
input		resetb;
input [7:0]	din;
input		dinstb;
output [7:0]	dout;
output		doutsync;
output		doutstb;
output		locked;

parameter SYNC = 8'h47;

reg [7:0]	dout;
reg		doutsync;
reg		doutstb;
reg		locked;

/* Internals */

// Free-running Modulo-188 counter
reg [7:0]	cnt188;

// Modulo-188 value when SYNCs are expected once locked.
reg [7:0]	syncindex;

// 6 deep queue of timestamps of every time a SYNC character is received.
// the timestamp is the value of the modulo-188 counter when a SYNC is received.
//
reg [7:0]	t0;	// Oldest timestamp
reg [7:0]	t1;
reg [7:0]	t2;
reg [7:0]	t3;
reg [7:0]	t4;
reg [7:0]	t5;	// Newest timestamp

// Modulo-188 free-running counter.
//
always @(posedge clk or negedge resetb) begin
   if (~resetb) begin
      cnt188 <= 0;
   end
   else begin
      if (dinstb) begin
         if (cnt188 == 187) begin
            cnt188 <= 0;
         end
         else begin
            cnt188 <= cnt188 + 1;
         end
      end
   end
end

// Timestamp queue.
//
always @(posedge clk or negedge resetb) begin
   if (~resetb) begin
      t0 <= 8'hff;  // Let's use FF as an invalid indicator, otherwise
      t1 <= 8'hff;  // we'd potentially get a premature lock..
      t2 <= 8'hff;
      t3 <= 8'hff;
      t4 <= 8'hff;
      t5 <= 8'hff;
   end
   else begin
      if (dinstb && (din == SYNC)) begin
         // Add new timestamp into our queue.
         t0 <= t1;   
         t1 <= t2;   
         t2 <= t3;   
         t3 <= t4;   
         t4 <= t5;   
         t5 <= cnt188;   
      end
   end
end

// Comparators.
wire t0equal = (t0 == cnt188) && (t0 != 8'hFF);
wire t1equal = (t1 == cnt188) && (t1 != 8'hFF);
wire t2equal = (t2 == cnt188) && (t2 != 8'hFF);
wire t3equal = (t3 == cnt188) && (t3 != 8'hFF);
wire t4equal = (t4 == cnt188) && (t4 != 8'hFF);
wire t5equal = (t5 == cnt188) && (t5 != 8'hFF);

// Count number of matches in all the prior timestamps and current modulo-188 time.
wire [3:0] numequal = t0equal + t1equal + t2equal + t3equal + t4equal + t5equal;

// Main sequential process.
//
always @(posedge clk or negedge resetb) begin
   if (~resetb) begin
      locked   <= 0;
      dout     <= 0;
      doutstb  <= 0;
      doutsync <= 0;
      syncindex <= 0;
   end
   else begin
      doutstb  <= 0;  // defaults..
      doutsync <= 0;
      if (dinstb) begin
         dout    <= din;
         doutstb <= 1;
         if (locked) begin
            if (cnt188 == syncindex) begin
               // We expect the data input to be a SYNC.  If it is not, we will
               // immediately drop lock.
               //
               if (din == SYNC) begin
                  $display (".. Received expected SYNC ..");
                  doutsync <= 1;
               end
               else begin
                  locked   <= 0;
                  $display (".. Did not receive expected SYNC, dropping lock! ");
               end
            end
         end
         else begin
            // The following line is the criteria for declaring LOCK.  It
            // says that when a SYNC is recieved we look at the current
            // timestamp, and if this timestamp is present in at least
            // 4 other times in the queue, than this SYNC is an actual SYNC.
            //
            if ((din == SYNC) && (numequal > 3)) begin
               doutsync <= 1;
               locked   <= 1;
               syncindex <= cnt188;
               $display (".. Received SYNC (cnt188=%0h) and declaring LOCK!", cnt188);
            end
         end
      end
   end
end

endmodule

// synopsys translate_off
module test;

reg		clk;
reg		resetb;
reg [7:0]	din;
reg		dinstb;
wire [7:0]	dout;
wire		doutsync;
wire		doutstb;
wire		locked;

// Instantiate the framer
framer framer (
   .clk(clk),
   .resetb(resetb),
   .din(din),
   .dinstb(dinstb),
   .dout(dout),
   .doutsync(doutsync),
   .doutstb(doutstb),
   .locked(locked)
);

initial begin
   fork
      monitor_cycles(100000); // just in case..
      genreset;
      genclock;
      begin
         gendata (20);
         $display ("Done sending good framed data, now sending trash..");
         genradomdata (188*3);  // 3 frames worth of trash.. should drop lock.
         $display ("Done sending trash.  Killing simulation.");
         $finish;
      end
      monitor_framer_output;
   join
end

// Generate VCD file for viewing.
initial begin
   $dumpfile ("framer.vcd");
   $dumpvars (0,test);   
end

// Just a generic task for watching total cycles.
task monitor_cycles;
   input	maxcycles;
   integer	maxcycles;
   integer	cycles;
   begin
      forever begin
         @(posedge clk);
         cycles = cycles + 1;
         if (cycles > maxcycles) begin
            $finish;
         end
      end
   end
endtask

// Watch output of framer.  Expect to see the pattern 1,2,3,4 after each SYNC.
// This is the pattern that will be injected into framer.
//
task monitor_framer_output;
   integer	cnt;
   integer	numerrors;
   begin
      numerrors = 0;
      forever begin
         @(posedge doutstb);
         #1;
         if (doutsync) begin
            $display ("Framer says SYNC..");
            cnt = 1;
            repeat (4) begin
               @(posedge doutstb);
               #1
               $display ("   and %h..", dout);
               if (dout != cnt) begin
                  numerrors = numerrors + 1;
                  $display ("!! Unexpected data from framer !! (%0d errors)", numerrors);
               end
               cnt = cnt + 1;
            end
         end
      end
   end
endtask

task genreset;
   begin
      resetb = 0;
      repeat (2) @(posedge clk);
      @(negedge clk);
      resetb = 1;
   end
endtask

task genclock;
   begin
      clk = 0;
      forever begin
         #10 clk = ~clk;
      end
   end
endtask

// Input framed data into the framer.  First 4 bytes of each frame should be
// a simple counting sequence that can then be checked at its output.
//
task gendata;
   input	numframes;
   
   integer	numframes;
   
   integer	cnt;
   begin
      cnt = $random;  // Start randomly in the frame sequence..
      repeat (numframes*188) begin
         repeat (3) @(posedge clk);
         if (cnt == 0) begin
            din = 8'h47;
            $display ("SYNC..");
         end
         else begin
            if (cnt < 5) begin
               din = cnt;
            end
            else begin
               din = $random;
               if (din == 8'h47) begin
                  $display ("   .. Non-SYNC 0x47 embedded in frame data !");
               end
            end
         end
      
         dinstb = 1;
         @(posedge clk);
         dinstb = 0;
         cnt = (cnt + 1) % 188;
      end
   end
endtask

// This will inject trash (no good framing) into framer.  Use this to show
// that it actually drops lock.
//
task genradomdata;
   input	numbytes;
   integer	numbytes;
   begin
      repeat (numbytes) begin
         repeat (3) @(posedge clk);
         din = $random;
         dinstb = 1;
         @(posedge clk);
         dinstb = 0;
      end
   end
endtask

endmodule
// synopsys translate_on
