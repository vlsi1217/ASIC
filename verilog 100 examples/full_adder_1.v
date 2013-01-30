module full_adder(a,b,cin,out,carry);
input a,b,cin;
output out,carry;

reg out,carry;
reg t1,t2,t3;

always@
          (a or b or cin)begin
          out   =    a^b^cin;
          t1    =    a&cin;
          t2    =    b&cin;
          t3    =    a&b;
          carry =    t1|t2|t3;
          end
endmodule
