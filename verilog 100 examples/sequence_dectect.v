/////////////////////////////////////////////////////////////////
////////Module name:sequence_detect                                                      ////////
////////Function         :detect the sequence  101110 in the data stream////////
////////Author             :Xiaoming Chen                                                         ////////
////////Date                 :18/12/2002                                                             ////////
/////////////////////////////////////////////////////////////////

`timescale 1ns/100ps
module sequence_dectect(in,         //the input data stream
                                                out,        //the output signal when detect a 101110 sequence
                                                clock,     //clock signal
                                                reset);  //reset signal
                                                
input                     in,clock,reset;
output                  out;
reg          [2:0]     state;
wire                      out;

parameter          START=3'b000,          //the initial state
                             A         =3'b001,          //state A
                             B         =3'b010,          //state B
                             C         =3'b011,          //state C
                             D         =3'b100,          //state D
                             E         =3'b101,          //state E
                             F         =3'b110;          //state F
                
 assign out=(state==E&&in==0)?1:0;    
            
 always@(posedge clock or negedge reset)
    if(!reset)
              begin
              state<=START;
              end
     else
         casex(state)
               START : if(in==1) state<=A;
               
                A    : if(in==0) state<=B;
                       else      state<=A;
                       
                B    : if(in==1) state<=C;
                       else      state<=A;
                       
                C    : if(in==1) state<=D;
                       else      state<=B;
                       
                D    : if(in==1) state<=E;
                       else      state<=B;
                       
                E    : if(in==0) state<=F;
                       else      state<=A;
                       
                F    : if(in==1) state<=C;
                       else      state<=A;
                       
                default:state=START;
          endcase
                                       
endmodule
