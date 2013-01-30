module lead_8bits_adder(a,b,cin,sum,cout);
input   [7:0]a,b;
input        cin;
output  [7:0]sum;
output       cout;

reg     [7:0]sum;
reg          cout;

always@(a or b or cin)
        begin
        sum[0]=(a[0]&b[0])|  (a[0]| b[0])&cin;
        sum[1]=(a[1]&b[1])|  (a[1]| b[1])&((a[0]^b[0])^cin);
        sum[2]=(a[2]&b[2])|  (a[2]| b[2])&((a[1]^b[1])^(a[0]^b[0])^cin);
        sum[3]=(a[3]&b[3])|  (a[3]| b[3])&((a[2]^b[2])^(a[1]^b[1])^(a[0]^b[0])^cin);
        sum[4]=(a[4]&b[4])|  (a[4]| b[4])&((a[3]^b[3])^(a[2]^b[2])^(a[1]^b[1])^(a[0]^b[0])^cin);
        sum[5]=(a[5]&b[5])|  (a[5]| b[5])&((a[4]^b[4])^(a[3]^b[3])^(a[2]^b[2])^(a[1]^b[1])^(a[0]^b[0])^cin);
        sum[6]=(a[6]&b[6])|  (a[6]| b[6])&((a[5]^b[5])^(a[4]^b[4])^(a[3]^b[3])^(a[2]^b[2])^(a[1]^b[1])^(a[0]^b[0])^cin);
        sum[7]=(a[7]&b[7])|  (a[7]| b[7])&((a[6]^b[6])^(a[5]^b[5])^(a[4]^b[4])^(a[3]^b[3])^(a[2]^b[2])^(a[1]^b[1])^(a[0]^b[0])^cin);
        
        cout=(a[7]^b[7])^(a[6]^b[6])^(a[5]^b[5])^(a[4]^b[4])^(a[3]^b[3])^(a[2]^b[2])^(a[1]^b[1])^(a[0]^b[0])^cin;
        end
        
endmodule
        