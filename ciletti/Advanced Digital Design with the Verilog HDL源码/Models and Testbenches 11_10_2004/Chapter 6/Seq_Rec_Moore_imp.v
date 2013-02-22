
module Seq_Rec_Moore_imp (D_out, D_in, clock, reset);  	
  output 		D_out;					 
  input 		D_in;
  input		clock, reset;			               
  reg 		last_bit, this_bit, flag;
  wire		D_out;

  always begin: wrapper_for_synthesis
    @ (posedge clock /* or posedge reset*/) begin: machine
        if (reset == 1) begin
            last_bit <= 0;
            //  this_bit <= 0;     
            // flag <= 0;
            disable machine; end
      else begin 							         
        //  last_bit <= this_bit;
        this_bit <= D_in;
        forever   						 
          @ (posedge clock  /* or posedge reset */) begin 		 
            if (reset == 1) begin  
              // last_bit <= 0;		 
              // this_bit <= 0;		 
              //flag <= 0;
              disable machine; end
            else begin
              last_bit <= this_bit;
              this_bit <= D_in; 
              flag <= 1; end 
        end  							 
      end 								 
    end // machine	
flag <= 0;					 
  end  // wrapper_for_synthesis

  assign D_out = (flag && (this_bit == last_bit));
endmodule


