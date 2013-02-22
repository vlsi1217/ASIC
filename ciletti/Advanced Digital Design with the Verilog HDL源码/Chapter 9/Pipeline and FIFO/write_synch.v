module write_synchronizer (write_synch, write_to_FIFO, clock, reset);
  output		write_synch;
  input		write_to_FIFO;
  input		clock, reset;
  reg		meta_synch, write_synch;

  always @ (negedge clock)
    if (reset == 1) begin
      meta_synch <= 0;
      write_synch <= 0;
    end
    else begin
      meta_synch <= write_to_FIFO;
      write_synch <= write_synch ? 0: meta_synch;
    end
endmodule



