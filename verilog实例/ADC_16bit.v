// 16-bit Analogue-Digital Converter
//
// +-----------------------------+
// |    Copyright 1996 DOULOS    |
// |    designer : Tim Pagden    |
// |     opened:  7 Jun 1996     |
// +-----------------------------+

`timescale 1 ns / 1 ps

module ADC_16bit (analog_in,digital_out);

parameter conversion_time = 25.0, // conversion_time in ns
				  // (see `timescale above)
	  charge_limit = 1000000; // = 1 million

input[63:0] analog_in;

// double-precision representation of a real-valued input port; a fix that enables 
// analog wires between modules to be coped with in Verilog. 
// Think of input[63:0] <variable> as the equivalent of MAST's electrical.

output[15:0] digital_out;

reg[15:0] delayed_digitized_signal;
reg[15:0] old_analog,current_analog;
reg[4:0] changed_bits;
reg[19:0] charge;
reg charge_ovr;
reg reset_charge;

/* SIGNALS:-
analog_in = 64-bit representation of a real-valued signal
analog_signal = real valued signal recovered from analog_in
analog_limited = analog_signal, limited to the real-valued input range of the ADC
digital_out = digitized 16bit 2's complement quantization of analog_limited
*/

/* function to convert analog_in to digitized_2s_comp_signal. 
Takes analog_in values from (+10.0 v - 1LSB) to -10.0 v and converts 
them to values from +32767 to -32768 respectively */

function[15:0] ADC_16b_10v_bipolar; 

parameter max_pos_digital_value = 32767,
	  max_in_signal = 10.0;

input[63:0] analog_in;

reg[15:0] digitized_2s_comp_signal;

real analog_signal,analog_abs,analog_limited;
integer digitized_signal;

begin
  analog_signal = $bitstoreal (analog_in);
  if (analog_signal < 0.0)
  begin
    analog_abs = -analog_signal;
    if (analog_abs > max_in_signal)
      analog_abs = max_in_signal;
    analog_limited = -analog_abs;
  end
  else
  begin
    analog_abs = analog_signal;
    if (analog_abs > max_in_signal)
      analog_abs = max_in_signal;
    analog_limited = analog_abs;
  end
  if (analog_limited == max_in_signal)
    digitized_signal = max_pos_digital_value;
  else
    digitized_signal = $rtoi (analog_limited * 3276.8);
  if (digitized_signal < 0)
    digitized_2s_comp_signal = 65536 - digitized_signal;
  else
    digitized_2s_comp_signal = digitized_signal;
  ADC_16b_10v_bipolar = digitized_2s_comp_signal;
end   

endfunction

/* This function determines the number of digital bit changes from
sample to sample; can be used to determine power consumption if required.
Task power_determine not yet implemented */

function[4:0] bit_changes;

input[15:0] old_analog,current_analog;

reg[4:0] bits_different;
integer i;

begin
  bits_different = 0;
  for (i=0;i<=15;i=i+1)
    if (current_analog[i] != old_analog[i])
      bits_different = bits_different + 1;
  bit_changes = bits_different;
end

endfunction

/* Block to allow power consumption to be measured (kind of). Reset_charge is used to periodically reset the charge accumulated value (which can be used to determine current consumption and thus power consumption) */

always @ (posedge reset_charge)
begin
  charge = 0;
  charge_ovr = 0;
end

/* This block only triggered when analog_in changes by an amount greater than 1LSB, a crude sort of scheduler */

always @ (ADC_16b_10v_bipolar (analog_in)) 
begin
  current_analog = ADC_16b_10v_bipolar (analog_in); // digitized_signal
  changed_bits = bit_changes (old_analog,current_analog);
  old_analog = current_analog;
  charge = charge + (changed_bits * 3);
  if (charge > charge_limit)
    charge_ovr = 1;
end

/* Block to implement conversion_time tpd; always block use to show
   difference between block and assign coding style */

always 
  # conversion_time delayed_digitized_signal = ADC_16b_10v_bipolar (analog_in);

assign digital_out = delayed_digitized_signal; 

endmodule
