// Simple VCS PLI example.
//
//
module pliread;

integer		fp;
reg [31:0]	a;

initial begin
   $pliopen ("pliread.dat", fp);
   $display ("Opened the file and got handle of %0d back", fp);
   
   $pliread (fp, "%x", a);
   $display ("a = %h", a);
   $pliread (fp, "%x", a);
   $display ("a = %h", a);
   $pliread (fp, "%d", a);
   $display ("a = %h", a);
   $pliclose (fp);
   $finish;
end
endmodule
